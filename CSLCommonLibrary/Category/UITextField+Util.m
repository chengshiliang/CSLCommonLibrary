//
//  UITextField+Util.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/19.
//

#import "UITextField+Util.h"
#import <CSLCommonLibrary/NSString+Util.h>
#import <objc/runtime.h>

@interface SLTextFieldAgent :NSObject
@property(assign, nonatomic)BOOL isFirst;
@property(copy, nonatomic)NSString *lastString;
@property(assign, nonatomic)BOOL disableEmoji;
@property(assign, nonatomic)NSInteger maxLength;
@end
@implementation SLTextFieldAgent
-(instancetype)init{
    if (self = [super init]) {
        self.isFirst = YES;
        self.maxLength = 0;
    }
    return self;
}
@end

@implementation UITextField (Util)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(setText:);
        SEL swizzledSelector = @selector(het_setText:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
-(SLTextFieldAgent *)agent{
    return objc_getAssociatedObject(self, @selector(setAgent:));
}
-(void)setAgent:(SLTextFieldAgent *)agent{
    [self addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    objc_setAssociatedObject(self, @selector(setAgent:), agent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark ------
- (void)het_setText:(NSString *)text {
    [self het_setText:text];
    if (!self.agent) {
        self.agent = [SLTextFieldAgent new];
    }
    if (self.agent.isFirst && !self.agent.lastString) {
        self.agent.isFirst = NO;
        self.agent.lastString = text;
    }
    
}

-(void)disableEmoji{
    if (!self.agent) {
        self.agent = [SLTextFieldAgent new];
    }
    self.agent.disableEmoji = YES;
    
}
-(void)textFieldChanged{
    if (self.text.length != 0) [self setNeedsDisplay];
    NSString *lang = [[[UIApplication sharedApplication] textInputMode] primaryLanguage];// 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        if (position) {
            return;
        }
    }
    
    if (self.agent.disableEmoji) {
        [self deleteEmojiText];
    }
    NSString *getStr = [self getSubString:self.text];
    if(getStr && getStr.length > 0) {
        self.text= getStr;
    }
    
    self.agent.lastString = self.text;
}

-(void)deleteEmojiText{
    UITextPosition* beginning = self.beginningOfDocument;
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    NSRange range;
    if([[NSString removeEmojiString:self.text] length]<self.text.length){
        range = NSMakeRange(location-(self.text.length-self.agent.lastString.length), length);
    }else{
        range = NSMakeRange(location, length);
    }
    [self setText:[NSString removeEmojiString:self.text]];
    beginning = self.beginningOfDocument;
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}
-(NSString *)getSubString:(NSString*)string {
    if (self.agent.maxLength <= 0) return @"";
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (length > self.agent.maxLength) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, self.agent.maxLength)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, self.agent.maxLength - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return nil;
}

-(void)maxLength:(NSInteger)length{
    if (!self.agent) {
        self.agent = [SLTextFieldAgent new];
    }
    self.agent.maxLength = length;
}
@end
