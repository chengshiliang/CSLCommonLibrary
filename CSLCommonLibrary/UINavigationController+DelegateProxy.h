//
//  UINavigationController+DelegateProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (DelegateProxy)
- (void)animationControllerForOperation:(nullable id <UIViewControllerInteractiveTransitioning>(^)(UINavigationController *navigationController,UINavigationControllerOperation operation,UIViewController *fromVC,UIViewController *toVC))operationBlock;
- (void)interactionControllerForAnimation:(nullable id <UIViewControllerInteractiveTransitioning>(^)(UINavigationController *navigationController,id <UIViewControllerAnimatedTransitioning>))interactionBlock;
@end

NS_ASSUME_NONNULL_END
