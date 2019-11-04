//
//  UINavigationController+DelegateProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "UINavigationController+DelegateProxy.h"
#import "CSLDelegateProxy.h"

#import <objc/runtime.h>

static void *kNavigationControllerOperatioKey = "kNavigationControllerOperatioKey";
static void *kNavigationControllerInteractionControllerKey = "kNavigationControllerInteractionControllerKey";

@implementation UINavigationController (DelegateProxy)
- (void)animationControllerForOperation:(nullable id <UIViewControllerInteractiveTransitioning>(^)(UINavigationController *navigationController,UINavigationControllerOperation operation,UIViewController *fromVC,UIViewController *toVC))operationBlock {
    [self delegateProxy];
    objc_setAssociatedObject(self, kNavigationControllerOperatioKey, operationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)interactionControllerForAnimation:(nullable id <UIViewControllerInteractiveTransitioning>(^)(UINavigationController *navigationController,id <UIViewControllerAnimatedTransitioning>))interactionBlock {
    objc_setAssociatedObject(self, kNavigationControllerInteractionControllerKey, interactionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// 返回动画对象
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    id <UIViewControllerAnimatedTransitioning> (^operationBlock)(UINavigationController *navigationController,UINavigationControllerOperation operation,UIViewController *fromVC,UIViewController *toVC) = objc_getAssociatedObject(self, kNavigationControllerOperatioKey);
    if (operationBlock) {
        return operationBlock(navigationController,operation,fromVC,toVC);
    }
    return nil;
}

// 返回动画进度对象
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    id <UIViewControllerInteractiveTransitioning> (^interactionBlock)(UINavigationController *navigationController,id <UIViewControllerAnimatedTransitioning> animationController) = objc_getAssociatedObject(self, kNavigationControllerInteractionControllerKey);
    if (interactionBlock) {
        return interactionBlock(navigationController,animationController);
    }
    return nil;
}

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(UINavigationControllerDelegate)];
        delegateProxy.delegate = self;
        self.delegate = (id<UINavigationControllerDelegate>)delegateProxy;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}
    
@end
