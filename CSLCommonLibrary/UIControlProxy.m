//
//  UIControlProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import "UIControlProxy.h"
#import <objc/runtime.h>

static void *kUIControl_delegate_Key = "kUIControl_delegate_Key";

@interface UIControlProxy()
{
    NSMutableArray *_controler;
    dispatch_queue_t _queue;
}
@end
@implementation UIControlProxy
+ (instancetype)share{
    static UIControlProxy *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UIControlProxy alloc]init];
    });
    return instance;
}

- (instancetype)init {
    if (self == [super init]) {
        _controler = [NSMutableArray array];
        _queue = dispatch_queue_create("com.slc.controlproxy", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)addTarget:(__weak CSLBaseControl *)target {
    __block NSMutableArray *arrM = _controler;
    dispatch_sync(_queue, ^{
        if (![arrM containsObject:target]) {
            [arrM addObject:target];
        }
    });
}

- (void)removeTarget:(__weak CSLBaseControl *)target {
    __block NSMutableArray *arrM = _controler;
    dispatch_sync(_queue, ^{
        if ([arrM containsObject:target]) {
            [arrM removeObject:target];
        }
    });
}

- (void)controlClick:(CSLBaseControl *)control {
    __block NSMutableArray *arrM = _controler;
    dispatch_sync(_queue, ^{
        for (CSLBaseControl * target in arrM) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(onClick:)]) {
                [self.delegate onClick:target];
            }
        }
    });
}

- (void)setDelegate:(id<UIControlProxyDelegate>)delegate {
    objc_setAssociatedObject(self, kUIControl_delegate_Key, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIControlProxyDelegate>)delegate {
    return objc_getAssociatedObject(self, kUIControl_delegate_Key);
}
@end
