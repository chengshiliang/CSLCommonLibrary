//
//  CAAnimation+DelegateProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "CAAnimation+DelegateProxy.h"
#import "CSLDelegateProxy.h"
#import <objc/runtime.h>

@implementation CAAnimation (DelegateProxy)
- (void)animationDidStart:(void(^)(CAAnimation *anim))animationDidStartBlock {
    [self.delegateProxy addSelector:@selector(animationDidStart:) callback:^(NSArray *params) {
        if (animationDidStartBlock && params && params.count ==1) {
            animationDidStartBlock(params[0]);
        }
    }];
}
- (void)animationDidStop:(void(^)(CAAnimation *anim))animationDidStopBlock {
    [self.delegateProxy addSelector:@selector(animationDidStop:) callback:^(NSArray *params) {
        if (animationDidStopBlock && params && params.count ==1) {
            animationDidStopBlock(params[0]);
        }
    }];
}

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(CAAnimationDelegate)];
        self.delegate = (id<CAAnimationDelegate>)delegateProxy;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}
@end
