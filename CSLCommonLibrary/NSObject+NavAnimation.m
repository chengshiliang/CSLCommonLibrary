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
static void *kNavAnimationTransitionKey = "kNavAnimationTransitionKey";
static void *kNavAnimationEndedKey = "kNavAnimationEndedKey";

@implementation NSObject (NavAnimation)
- (void)transitionDurationBlock:(NSTimeInterval(^)(_Nullable id <UIViewControllerContextTransitioning> transitionContext))transitionDurationBlock {
    objc_setAssociatedObject(self, kNavAnimationTransitionDurationKey, transitionDurationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)animateTransitionBlock:(void(^)(id <UIViewControllerContextTransitioning> transitionContext))animateTransitionBlock {
    [self delegateProxy];
    objc_setAssociatedObject(self, kNavAnimationTransitionKey, animateTransitionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)animationEndedBlock:(void(^)(BOOL transitionCompleted))animationEndedBlock {
    objc_setAssociatedObject(self, kNavAnimationEndedKey, animationEndedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)animationEnded:(BOOL)transitionCompleted{
    void(^animationEndedBlock)(BOOL transitionComplet) = objc_getAssociatedObject(self, kNavAnimationEndedKey);
    if (animationEndedBlock) {
        animationEndedBlock(transitionCompleted);
    }
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval(^transitionDurationBlock)(_Nullable id <UIViewControllerContextTransitioning> transition) = objc_getAssociatedObject(self, kNavAnimationTransitionDurationKey);
    if (transitionDurationBlock) {
        return transitionDurationBlock(transitionContext);
    }
    return 0.0f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    void(^animateTransitionBlock)(id <UIViewControllerContextTransitioning> transitionContext) = objc_getAssociatedObject(self, kNavAnimationTransitionKey);
    if (animateTransitionBlock) {
        animateTransitionBlock(transitionContext);
    }
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
@end
