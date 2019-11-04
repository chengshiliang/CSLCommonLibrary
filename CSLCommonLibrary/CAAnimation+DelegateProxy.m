//
//  CAAnimation+DelegateProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "CAAnimation+DelegateProxy.h"
#import "CSLDelegateProxy.h"
#import <objc/runtime.h>

static void * kCAAnimationDidStartKey = "kCAAnimationDidStartKey";
static void * kCAAnimationDidStopKey = "kCAAnimationDidStopKey";

@implementation CAAnimation (DelegateProxy)
- (void)animationDidStartBlock:(void(^)(CAAnimation *anim))animationDidStartBlock {
    objc_setAssociatedObject(self, kCAAnimationDidStartKey, animationDidStartBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)animationDidStopBlock:(void(^)(CAAnimation *anim))animationDidStopBlock {
    objc_setAssociatedObject(self, kCAAnimationDidStopKey, animationDidStopBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)animationDidStart:(CAAnimation *)anim {
    void(^animationDidStartBlock)(CAAnimation * animation) = objc_getAssociatedObject(self, kCAAnimationDidStartKey);
    if (animationDidStartBlock) {
        animationDidStartBlock(anim);
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void(^animationDidStopBlock)(CAAnimation * animation) = objc_getAssociatedObject(self, kCAAnimationDidStopKey);
    if (animationDidStopBlock) {
        animationDidStopBlock(anim);
    }
}

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(CAAnimationDelegate)];
        delegateProxy.delegate = self;
        self.delegate = (id<CAAnimationDelegate>)delegateProxy;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}
@end
