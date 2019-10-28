//
//  CSLBaseControl.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import "CSLBaseControl.h"
#import "UIControlProxy.h"
#import "CSLDelegateProxy.h"
#import <objc/runtime.h>

#import "NSObject+Base.h"

@interface CSLBaseControl()
@property (nonatomic, copy) ControlReturnBlock block;
@property (nonatomic, weak) NSObject *target;
@end
@implementation CSLBaseControl

- (instancetype)initWithTarget:(NSObject *)target controlEvent:(UIControlEvents)controlEvent block:(ControlReturnBlock)block {
    if (self == [super init]) {
        self.block = [block copy];
        self.target = target;
        [[UIControlProxy share]addTarget:self];
        __weak __typeof(self)weakSelf = self;
        [self.delegateProxy addSelector:@selector(onClick:) callback:^(NSArray *params) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            ControlReturnBlock block;
            @synchronized (strongSelf) {
                block = strongSelf.block;
            }
            if (block && params && params.count == 1) {
                block(params[0]);
            }
        }];
        [self addTarget:[UIControlProxy share] action:@selector(controlClick:) forControlEvents:controlEvent];
        
        [self swizzDeallocMethod:self.target callback:^(NSObject * _Nonnull __unsafe_unretained deallocObj) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            @synchronized (strongSelf) {
                strongSelf.block = nil;
                strongSelf.target = nil;
            }
            [strongSelf removeTarget:[UIControlProxy share] action:@selector(controlClick:) forControlEvents:controlEvent];
            [[UIControlProxy share]removeTarget:strongSelf];
        }];
    }
    return self;
}

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(UIControlProxyDelegate)];
        [UIControlProxy share].delegate = (id<UIControlProxyDelegate>)delegateProxy;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}

- (void)dealloc{
    NSLog(@"base control dealloc");
}
@end
