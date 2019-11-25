//
//  NSObject+DelegateProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/21.
//

#import "UIViewController+DelegateProxy.h"
#import "CSLDelegateProxy.h"
#import <objc/runtime.h>

static void *kPresentAnimationTransitionPresentControllerKey = "kPresentAnimationTransitionPresentControllerKey";
static void *kPresentAnimationTransitionDissmissControllerKey = "kPresentAnimationTransitionDissmissControllerKey";
static void *kPresentAnimationTransitionInteractionPresentingControllerKey = "kPresentAnimationTransitionInteractionPresentingControllerKey";
static void *kPresentAnimationTransitionInteractionDissmissedControllerKey = "kPresentAnimationTransitionInteractionDissmissedControllerKey";

@implementation UIViewController (DelegateProxy)
- (void)addPresentedController:(UIViewController *)presentedController {
    presentedController.transitioningDelegate = (id <UIViewControllerTransitioningDelegate>)[self delegateProxy];
}

- (void)presentingControllerBlock:(nullable id <UIViewControllerAnimatedTransitioning>(^)(UIViewController *presentingController, UIViewController *sourceController))presentingControllerBlock {
    objc_setAssociatedObject(self, &kPresentAnimationTransitionPresentControllerKey, presentingControllerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)dismissedControllerBlock:(nullable id <UIViewControllerAnimatedTransitioning>(^)(UIViewController *dismissedController))dismissedControllerBlock {
    objc_setAssociatedObject(self, &kPresentAnimationTransitionDissmissControllerKey, dismissedControllerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)interactionPresentingControllerBlock:(nullable id <UIViewControllerInteractiveTransitioning>(^)(id <UIViewControllerAnimatedTransitioning> animator))interactionPresentingControllerBlock {
    objc_setAssociatedObject(self, &kPresentAnimationTransitionInteractionPresentingControllerKey, interactionPresentingControllerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)interactionDismissedControllerBlock:(nullable id <UIViewControllerInteractiveTransitioning>(^)(id <UIViewControllerAnimatedTransitioning> animator))interactionDismissedControllerBlock {
    objc_setAssociatedObject(self, &kPresentAnimationTransitionInteractionDissmissedControllerKey, interactionDismissedControllerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    id <UIViewControllerAnimatedTransitioning>(^presentingControllerBlock)(UIViewController *presentingController, UIViewController *sourceController) = objc_getAssociatedObject(self, &kPresentAnimationTransitionPresentControllerKey);
    if (presentingControllerBlock) {
        return presentingControllerBlock(presenting,source);
    }
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    id <UIViewControllerAnimatedTransitioning>(^dismissedControllerBlock)(UIViewController *dismissedController) = objc_getAssociatedObject(self, &kPresentAnimationTransitionDissmissControllerKey);
    if (dismissedControllerBlock) {
        return dismissedControllerBlock(dismissed);
    }
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    id <UIViewControllerInteractiveTransitioning>(^interactionPresentingControllerBlock)(id <UIViewControllerAnimatedTransitioning> animator) = objc_getAssociatedObject(self, &kPresentAnimationTransitionInteractionDissmissedControllerKey);
    if (interactionPresentingControllerBlock) {
        return interactionPresentingControllerBlock(animator);
    }
    return  nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    id <UIViewControllerInteractiveTransitioning>(^interactionDismissedControllerBlock)(id <UIViewControllerAnimatedTransitioning> animator) = objc_getAssociatedObject(self, &kPresentAnimationTransitionInteractionPresentingControllerKey);
    if (interactionDismissedControllerBlock) {
        return interactionDismissedControllerBlock(animator);
    }
    return nil;
}

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(UIViewControllerTransitioningDelegate)];
        delegateProxy.delegate = self;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}
@end
