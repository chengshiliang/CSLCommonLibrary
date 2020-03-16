//
//  SLStand.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2020/3/10.
//

#import "SLStand.h"
#import "SLUIConsts.h"
#include <execinfo.h>
#import <mach/mach.h>
#include <dlfcn.h>
#include <pthread.h>
#include <sys/types.h>
#include <limits.h>
#include <string.h>
#include <mach-o/dyld.h>
#include <mach-o/nlist.h>
#import "SSZipArchive.h"
#import "SLUtil.h"

@interface SLBacktraceCallback : NSObject

@end
#if defined(__arm64__)
#define DETAG_INSTRUCTION_ADDRESS(A) ((A) & ~(3UL))
#define yz_THREAD_STATE_COUNT ARM_THREAD_STATE64_COUNT
#define yz_THREAD_STATE ARM_THREAD_STATE64
#define yz_FRAME_POINTER __fp
#define yz_STACK_POINTER __sp
#define yz_INSTRUCTION_ADDRESS __pc

#elif defined(__arm__)
#define DETAG_INSTRUCTION_ADDRESS(A) ((A) & ~(1UL))
#define yz_THREAD_STATE_COUNT ARM_THREAD_STATE_COUNT
#define yz_THREAD_STATE ARM_THREAD_STATE
#define yz_FRAME_POINTER __r[7]
#define yz_STACK_POINTER __sp
#define yz_INSTRUCTION_ADDRESS __pc

#elif defined(__x86_64__)
#define DETAG_INSTRUCTION_ADDRESS(A) (A)
#define yz_THREAD_STATE_COUNT x86_THREAD_STATE64_COUNT
#define yz_THREAD_STATE x86_THREAD_STATE64
#define yz_FRAME_POINTER __rbp
#define yz_STACK_POINTER __rsp
#define yz_INSTRUCTION_ADDRESS __rip

#elif defined(__i386__)
#define DETAG_INSTRUCTION_ADDRESS(A) (A)
#define yz_THREAD_STATE_COUNT x86_THREAD_STATE32_COUNT
#define yz_THREAD_STATE x86_THREAD_STATE32
#define yz_FRAME_POINTER __ebp
#define yz_STACK_POINTER __esp
#define yz_INSTRUCTION_ADDRESS __eip

#endif
#define CALL_INSTRUCTION_FROM_RETURN_ADDRESS(A) (DETAG_INSTRUCTION_ADDRESS((A)) - 1)

#if defined(__LP64__)
#define TRACE_FMT         "%-4d%-31s 0x%016lx %s + %lu"
#define POINTER_FMT       "0x%016lx"
#define POINTER_SHORT_FMT "0x%lx"
#define yz_NLIST struct nlist_64
#else
#define TRACE_FMT         "%-4d%-31s 0x%08lx %s + %lu"
#define POINTER_FMT       "0x%08lx"
#define POINTER_SHORT_FMT "0x%lx"
#define yz_NLIST struct nlist
#endif
typedef struct StackFrameEntry{
    const struct StackFrameEntry *const previous;
    const uintptr_t return_address;
} StackFrameEntry;
@implementation SLBacktraceCallback
static mach_port_t main_thread_id;
+ (void)load {
    main_thread_id = mach_thread_self();
}

+ (NSString *)backtraceOfMainThread {
    return backtraceOfThread(machThreadFromMainThread());
}

uintptr_t firstCmdAfterHeader(const struct mach_header* const header) {
    switch(header->magic) {
        case MH_MAGIC:
        case MH_CIGAM:
            return (uintptr_t)(header + 1);
        case MH_MAGIC_64:
        case MH_CIGAM_64:
            return (uintptr_t)(((struct mach_header_64*)header) + 1);
        default:
            return 0;  // Header is corrupt
    }
}

uint32_t imageIndexContainingAddress(const uintptr_t address) {
    const uint32_t imageCount = _dyld_image_count();
    const struct mach_header* header = 0;
    
    for(uint32_t iImg = 0; iImg < imageCount; iImg++) {
        header = _dyld_get_image_header(iImg);
        if(header != NULL) {
            // Look for a segment command with this address within its range.
            uintptr_t addressWSlide = address - (uintptr_t)_dyld_get_image_vmaddr_slide(iImg);
            uintptr_t cmdPtr = firstCmdAfterHeader(header);
            if(cmdPtr == 0) {
                continue;
            }
            for(uint32_t iCmd = 0; iCmd < header->ncmds; iCmd++) {
                const struct load_command* loadCmd = (struct load_command*)cmdPtr;
                if(loadCmd->cmd == LC_SEGMENT) {
                    const struct segment_command* segCmd = (struct segment_command*)cmdPtr;
                    if(addressWSlide >= segCmd->vmaddr &&
                       addressWSlide < segCmd->vmaddr + segCmd->vmsize) {
                        return iImg;
                    }
                }
                else if(loadCmd->cmd == LC_SEGMENT_64) {
                    const struct segment_command_64* segCmd = (struct segment_command_64*)cmdPtr;
                    if(addressWSlide >= segCmd->vmaddr &&
                       addressWSlide < segCmd->vmaddr + segCmd->vmsize) {
                        return iImg;
                    }
                }
                cmdPtr += loadCmd->cmdsize;
            }
        }
    }
    return UINT_MAX;
}

uintptr_t segmentBaseOfImageIndex(const uint32_t idx) {
    const struct mach_header* header = _dyld_get_image_header(idx);
    
    // Look for a segment command and return the file image address.
    uintptr_t cmdPtr = firstCmdAfterHeader(header);
    if(cmdPtr == 0) {
        return 0;
    }
    for(uint32_t i = 0;i < header->ncmds; i++) {
        const struct load_command* loadCmd = (struct load_command*)cmdPtr;
        if(loadCmd->cmd == LC_SEGMENT) {
            const struct segment_command* segmentCmd = (struct segment_command*)cmdPtr;
            if(strcmp(segmentCmd->segname, SEG_LINKEDIT) == 0) {
                return segmentCmd->vmaddr - segmentCmd->fileoff;
            }
        }
        else if(loadCmd->cmd == LC_SEGMENT_64) {
            const struct segment_command_64* segmentCmd = (struct segment_command_64*)cmdPtr;
            if(strcmp(segmentCmd->segname, SEG_LINKEDIT) == 0) {
                return (uintptr_t)(segmentCmd->vmaddr - segmentCmd->fileoff);
            }
        }
        cmdPtr += loadCmd->cmdsize;
    }
    return 0;
}

bool sl_dladdr(const uintptr_t address, Dl_info* const info) {
    info->dli_fname = NULL;
    info->dli_fbase = NULL;
    info->dli_sname = NULL;
    info->dli_saddr = NULL;
    
    const uint32_t idx = imageIndexContainingAddress(address);
    if(idx == UINT_MAX) {
        return false;
    }
    const struct mach_header* header = _dyld_get_image_header(idx);
    const uintptr_t imageVMAddrSlide = (uintptr_t)_dyld_get_image_vmaddr_slide(idx);
    const uintptr_t addressWithSlide = address - imageVMAddrSlide;
    const uintptr_t segmentBase = segmentBaseOfImageIndex(idx) + imageVMAddrSlide;
    if(segmentBase == 0) {
        return false;
    }
    
    info->dli_fname = _dyld_get_image_name(idx);
    info->dli_fbase = (void*)header;
    
    // Find symbol tables and get whichever symbol is closest to the address.
    const yz_NLIST* bestMatch = NULL;
    uintptr_t bestDistance = ULONG_MAX;
    uintptr_t cmdPtr = firstCmdAfterHeader(header);
    if(cmdPtr == 0) {
        return false;
    }
    for(uint32_t iCmd = 0; iCmd < header->ncmds; iCmd++) {
        const struct load_command* loadCmd = (struct load_command*)cmdPtr;
        if(loadCmd->cmd == LC_SYMTAB) {
            const struct symtab_command* symtabCmd = (struct symtab_command*)cmdPtr;
            const yz_NLIST* symbolTable = (yz_NLIST*)(segmentBase + symtabCmd->symoff);
            const uintptr_t stringTable = segmentBase + symtabCmd->stroff;
            
            for(uint32_t iSym = 0; iSym < symtabCmd->nsyms; iSym++) {
                // If n_value is 0, the symbol refers to an external object.
                if(symbolTable[iSym].n_value != 0) {
                    uintptr_t symbolBase = symbolTable[iSym].n_value;
                    uintptr_t currentDistance = addressWithSlide - symbolBase;
                    if((addressWithSlide >= symbolBase) &&
                       (currentDistance <= bestDistance)) {
                        bestMatch = symbolTable + iSym;
                        bestDistance = currentDistance;
                    }
                }
            }
            if(bestMatch != NULL) {
                info->dli_saddr = (void*)(bestMatch->n_value + imageVMAddrSlide);
                info->dli_sname = (char*)((intptr_t)stringTable + (intptr_t)bestMatch->n_un.n_strx);
                if(*info->dli_sname == '_') {
                    info->dli_sname++;
                }
                // This happens if all symbols have been stripped.
                if(info->dli_saddr == info->dli_fbase && bestMatch->n_type == 3) {
                    info->dli_sname = NULL;
                }
                break;
            }
        }
        cmdPtr += loadCmd->cmdsize;
    }
    return true;
}

void symbolicate(const uintptr_t* const backtraceBuffer,
                    Dl_info* const symbolsBuffer,
                    const int numEntries,
                    const int skippedEntries){
    int i = 0;
    
    if(!skippedEntries && i < numEntries) {
        sl_dladdr(backtraceBuffer[i], &symbolsBuffer[i]);
        i++;
    }
    
    for(; i < numEntries; i++) {
        sl_dladdr(CALL_INSTRUCTION_FROM_RETURN_ADDRESS(backtraceBuffer[i]), &symbolsBuffer[i]);
    }
}

bool fillThreadStateIntoMachineContext(thread_t thread, _STRUCT_MCONTEXT *machineContext) {
    mach_msg_type_number_t state_count = yz_THREAD_STATE_COUNT;
    kern_return_t kr = thread_get_state(thread, yz_THREAD_STATE, (thread_state_t)&machineContext->__ss, &state_count);
    return (kr == KERN_SUCCESS);
}

kern_return_t mach_copyMem(const void *const src, void *const dst, const size_t numBytes){
    vm_size_t bytesCopied = 0;
    return vm_read_overwrite(mach_task_self(), (vm_address_t)src, (vm_size_t)numBytes, (vm_address_t)dst, &bytesCopied);
}

thread_t machThreadFromMainThread() {
    mach_msg_type_number_t count;
    thread_act_array_t list;
    task_threads(mach_task_self(), &list, &count);
    
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    [[NSThread mainThread] setName:[NSString stringWithFormat:@"%f", currentTimestamp]];
    return (thread_t)main_thread_id;
}

const char* lastPathEntry(const char* const path) {
    if(path == NULL) {
        return NULL;
    }
    
    char* lastFile = strrchr(path, '/');
    return lastFile == NULL ? path : lastFile + 1;
}

NSString* logBacktraceEntry(const int entryNum,
                               const uintptr_t address,
                               const Dl_info* const dlInfo) {
    char faddrBuff[20];
    char saddrBuff[20];
    
    const char* fname = lastPathEntry(dlInfo->dli_fname);
    if(fname == NULL) {
        sprintf(faddrBuff, POINTER_FMT, (uintptr_t)dlInfo->dli_fbase);
        fname = faddrBuff;
    }
    
    uintptr_t offset = address - (uintptr_t)dlInfo->dli_saddr;
    const char* sname = dlInfo->dli_sname;
    if(sname == NULL) {
        sprintf(saddrBuff, POINTER_SHORT_FMT, (uintptr_t)dlInfo->dli_fbase);
        sname = saddrBuff;
        offset = address - (uintptr_t)dlInfo->dli_fbase;
    }
    return [NSString stringWithFormat:@"%-30s  0x%08" PRIxPTR " %s + %lu\n" ,fname, (uintptr_t)address, sname, offset];
}

NSString *backtraceOfThread(thread_t thread) {
    uintptr_t backtraceBuffer[50];
    int i = 0;
    NSMutableString *resultString = [[NSMutableString alloc] initWithFormat:@"Backtrace of Thread %u:\n", thread];
    
    _STRUCT_MCONTEXT machineContext;
    if(!fillThreadStateIntoMachineContext(thread, &machineContext)) {
        return [NSString stringWithFormat:@"Fail to get information about thread: %u", thread];
    }
    
    const uintptr_t instructionAddress = (&machineContext)->__ss.yz_INSTRUCTION_ADDRESS;
    backtraceBuffer[i] = instructionAddress;
    ++i;
    
    uintptr_t linkRegister = 0;
    #if defined(__i386__) || defined(__x86_64__)
        linkRegister = 0;
    #else
        linkRegister = (&machineContext)->__ss.__lr;
    #endif
    if (linkRegister) {
        backtraceBuffer[i] = linkRegister;
        i++;
    }
    
    if(instructionAddress == 0) {
        return @"Fail to get instruction address";
    }
    
    StackFrameEntry frame = {0};
    const uintptr_t framePtr = (&machineContext)->__ss.yz_FRAME_POINTER;
    if(framePtr == 0 ||
        mach_copyMem((void *)framePtr, &frame, sizeof(frame)) != KERN_SUCCESS) {
        return @"Fail to get frame pointer";
    }
    
    for(; i < 50; i++) {
        backtraceBuffer[i] = frame.return_address;
        if(backtraceBuffer[i] == 0 ||
           frame.previous == 0 ||
           mach_copyMem(frame.previous, &frame, sizeof(frame)) != KERN_SUCCESS) {
            break;
        }
    }
    
    int backtraceLength = i;
    Dl_info symbolicated[backtraceLength];
    symbolicate(backtraceBuffer, symbolicated, backtraceLength, 0);
    for (int i = 0; i < backtraceLength; ++i) {
        [resultString appendFormat:@"%@", logBacktraceEntry(i, backtraceBuffer[i], &symbolicated[i])];
    }
    [resultString appendFormat:@"\n"];
    return [resultString copy];
}

@end

@interface StandLogFile : NSObject
@property (nonatomic,assign) float MAXFileLength;// 最大本地日志，高于这个数字，就上传，单位 kb

- (void)writefile:(NSString *)string;
+ (instancetype)sharedInstance;
@end

static const float DefaultMAXLogFileLength = 50;
@implementation StandLogFile
static StandLogFile *shareLog;
#pragma mark -  日志模块
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareLog = [[[self class] alloc] init];
    });
    return shareLog;
}

-(NSString *)getLogPath{
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    
    NSString *filePath = [homePath stringByAppendingPathComponent:@"SLStand.log"];
    return filePath;
}

-(NSString *)getLogZipPath{
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *zipPath = [NSString stringWithFormat:@"%@/SLStand.zip",cachesDirectory];
    [myFileManager removeItemAtPath:zipPath error:nil];
    return zipPath;
}

- (void)writefile:(NSString *)string
{
    NSString *filePath = [shareLog getLogPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        NSString *str = @"卡顿日志";
        NSString *systemVersion = [NSString stringWithFormat:@"手机版本: %@",[SLUtil iphoneSystemVersion]];
        NSString *iphoneType = [NSString stringWithFormat:@"手机型号: %@",[SLUtil iphoneType]];
        str = [NSString stringWithFormat:@"%@\n%@\n%@",str,systemVersion,iphoneType];
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
    }else{
        float filesize = -1.0;
        if ([fileManager fileExistsAtPath:filePath]) {
            NSDictionary *fileDic = [fileManager attributesOfItemAtPath:filePath error:nil];
            unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
            filesize = 1.0 * size / 1024;
        }
        
        NSLog(@"文件大小 filesize = %lf",filesize);
        NSLog(@"文件内容 %@",string);
        NSLog(@" ---------------------------------");
        
        if (filesize > (shareLog.MAXFileLength > 0 ? shareLog.MAXFileLength:DefaultMAXLogFileLength)) {
            // 上传到服务器
            NSLog(@" 上传到服务器");
            [shareLog update];
            [shareLog clearLocalLogFile];
            [shareLog writeToLocalLogFilePath:filePath contentStr:string];
        }else{
            NSLog(@"继续写入本地");
            [shareLog writeToLocalLogFilePath:filePath contentStr:string];
        }
    }
    
}

-(void)writeToLocalLogFilePath:(NSString *)localFilePath contentStr:(NSString *)contentStr{
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:localFilePath];
    
    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *str = [NSString stringWithFormat:@"\n%@\n%@",datestr,contentStr];
    
    NSData* stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; //追加写入数据
    
    [fileHandle closeFile];
}

-(BOOL)clearLocalLogFile{
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    return [myFileManager removeItemAtPath:[shareLog getLogPath] error:nil];
    
}

-(BOOL)clearLocalLogZipFile{
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    return [myFileManager removeItemAtPath:[shareLog getLogZipPath] error:nil];
    
}

-(BOOL)clearLocalLogZipAndLogFile{
    return [shareLog clearLocalLogFile] && [shareLog clearLocalLogZipFile];
    
}
// 上传日志
-(void)update{
    NSString *zipPath = [shareLog getLogZipPath];
    NSString *password = nil;
    NSMutableArray *filePaths = [[NSMutableArray alloc] init];
    [filePaths addObject:[shareLog getLogPath]];
    BOOL success = [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:filePaths withPassword:password.length > 0 ? password : nil];
    
    if (success) {
        NSLog(@"压缩成功");
        
    }else{
        NSLog(@"压缩失败");
    }
    
    
}

@end

// minimum
static const NSInteger MXRMonitorRunloopMinOneStandstillMillisecond = 20;
static const NSInteger MXRMonitorRunloopMinStandstillCount = 1;

// default
// 超过多少毫秒为一次卡顿
static const NSInteger MXRMonitorRunloopOneStandstillMillisecond = 50;
// 多少次卡顿纪录为一次有效卡顿
static const NSInteger MXRMonitorRunloopStandstillCount = 1;

static SLStand *share;

@interface SLStand()
@property (nonatomic, assign) CFRunLoopObserverRef observer;  // 观察者
@property (nonatomic, strong) dispatch_semaphore_t semaphore; // 信号量
@property (nonatomic, assign) CFRunLoopActivity activity;     // 状态
@property (nonatomic, assign) BOOL isCancel; //f是否取消检测
@property (nonatomic, assign) NSInteger countTime; // 耗时次数
@property (nonatomic, strong) NSMutableArray *backtrace;
@end

@implementation SLStand
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[[self class] alloc] init];
        share.limitMillisecond = MXRMonitorRunloopOneStandstillMillisecond;
        share.standstillCount  = MXRMonitorRunloopStandstillCount;
    });
    return share;
}

- (void)setLimitMillisecond:(NSInteger)limitMillisecond{
    [share willChangeValueForKey:@"limitMillisecond"];
    _limitMillisecond = MAX(MXRMonitorRunloopMinOneStandstillMillisecond, limitMillisecond);
    [share didChangeValueForKey:@"limitMillisecond"];
}

- (void)setStandstillCount:(NSInteger)standstillCount{
    [share willChangeValueForKey:@"standstillCount"];
    _standstillCount = MAX(standstillCount, MXRMonitorRunloopMinStandstillCount);
    [share didChangeValueForKey:@"standstillCount"];
}

- (void)startMonitor {
    share.isCancel = NO;
    [share registerObserver];
}

- (void)endMonitor {
    share.isCancel = YES;
    if(!share.observer) return;
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), share.observer, kCFRunLoopCommonModes);
    CFRelease(share.observer);
    share.observer = NULL;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    share.activity = activity;
    dispatch_semaphore_t semaphore = share.semaphore;
    dispatch_semaphore_signal(semaphore);
}

-(void)registerObserver{
    CFRunLoopObserverContext context = {0, (__bridge void *)share, NULL, NULL};
    share.observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                        kCFRunLoopAllActivities,
                                        YES,
                                        0,
                                        &runLoopObserverCallBack,
                                        &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), share.observer, kCFRunLoopCommonModes);
    share.semaphore = dispatch_semaphore_create(0); ////Dispatch Semaphore保证同步
    
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            if (share.isCancel) return;
            dispatch_semaphore_wait(share.semaphore, dispatch_time(DISPATCH_TIME_NOW, share.limitMillisecond * NSEC_PER_MSEC));
            if (share.activity != kCFRunLoopBeforeSources && share.activity != kCFRunLoopAfterWaiting) continue;
            if (++share.countTime < share.standstillCount){
                NSLog(@"standstillCount %ld",(long)share.countTime);
                continue;
            }
            [share logStack];
            
            NSString *backtrace = [SLBacktraceCallback backtraceOfMainThread];
            NSLog(@"++++%@",backtrace);
            [[StandLogFile sharedInstance] writefile:backtrace];
            
            !share.callbackWhenStandStill?:share.callbackWhenStandStill();
            share.countTime = 0;
        }
    });
}



- (void)logStack {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    share.backtrace = [NSMutableArray arrayWithCapacity:frames];
    for ( i = 0 ; i < frames ; i++ ){
        [share.backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    NSLog(@"==========检测到卡顿之后调用堆栈==========\n %@ \n",share.backtrace);
}
@end
