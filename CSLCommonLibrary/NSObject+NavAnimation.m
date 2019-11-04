//
//  NSObject+NavAnimation.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "NSObject+NavAnimation.h"
#import "CSLDelegateProxy.h"

#import <objc/runtime.h>

static void *kNavAnimationTransitionDurationKey = "kNavAnimationTransitionDurationKey";

@implementation NSObject (NavAnimation)
- (void)transitionDurationBlock:(NSTimeInterval(^)(_Nullable id <UIViewControllerContextTransitioning> transitionContext))transitionDurationBlock {
    objc_setAssociatedObject(self, kNavAnimationTransitionDurationKey, transitionDurationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)animateTransition:(void(^)(id <UIViewControllerContextTransitioning> transitionContext))animateTransitionBlock {
    [self.delegateProxy addSelector:@selector(animateTransition:) callback:^(NSArray *params) {
        if (animateTransitionBlock && params && params.count == 2) {
            animateTransitionBlock(params[1]);
        }
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval(^transitionDurationBlock)(_Nullable id <UIViewControllerContextTransitioning> transition) = objc_getAssociatedObject(self, kNavAnimationTransitionDurationKey);
    if (transitionDurationBlock) {
        return transitionDurationBlock(transitionContext);
    }
    return 0.0f;
}

- (void)animationEnded:(void(^)(BOOL transitionCompleted))animationEndedBlock {
    [self.delegateProxy addSelector:@selector(animationEnded:) callback:^(NSArray *params) {
        NSLog(@"transition animationEnded%@", params);
        if (animationEndedBlock && params && params.count ==1) {
            animationEndedBlock([params[0] boolValue]);
        }
    }];
}

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(UIViewControllerAnimatedTransitioning)];
        delegateProxy.delegate = self;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}

//- (void)dealloc {
//    NSLog(@"nav animation dealloc");
//}
@end
