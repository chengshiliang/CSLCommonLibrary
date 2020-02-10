//
//  UIViewController+SLBase.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import "UIViewController+SLBase.h"
#import <CSLCommonLibrary/UIImage+SLBase.h>
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLCommonLibrary/NSObject+Base.h>
#import <CSLCommonLibrary/UIViewController+DelegateProxy.h>
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>
#import <CSLCommonLibrary/NSObject+NavAnimation.h>
#import <objc/runtime.h>

@implementation SLPresentTransitionAnimation

- (instancetype)init {
    if (self == [super init]) {
        NSTimeInterval transitionDuration = 0.3f;
        [self transitionDurationBlock:^NSTimeInterval(id<UIViewControllerContextTransitioning>  _Nullable transitionContext) {
            return transitionDuration;
        }];
        [self animateTransitionBlock:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
            UIView *containerView = transitionContext.containerView;
            UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UIView *toView;
            if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
                toView = [transitionContext viewForKey:UITransitionContextToViewKey];
            } else {
                toView = toViewController.view;
            }
            
            [containerView addSubview:toView];
            toView.frame = CGRectOffset(toView.frame, 0.f, kScreenHeight);;
            [UIView animateWithDuration:transitionDuration animations:^{
                toView.frame = CGRectOffset(toView.frame, 0.f, -kScreenHeight);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }];
    }
    return self;
}

@end

@implementation SLDissmissTransitionAnimation

- (instancetype)init {
    if (self == [super init]) {
        NSTimeInterval transitionDuration = 0.5f;
        [self transitionDurationBlock:^NSTimeInterval(id<UIViewControllerContextTransitioning>  _Nullable transitionContext) {
            return transitionDuration;
        }];
        [self animateTransitionBlock:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
            UIView *containerView = transitionContext.containerView;
            UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            
            UIView *fromView;
            UIView *toView;
            if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
                fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
                toView = [transitionContext viewForKey:UITransitionContextToViewKey];
            } else {
                fromView = fromViewController.view;
                toView = toViewController.view;
            }
            
            [containerView addSubview:toView];
            [containerView bringSubviewToFront:fromView];
            [UIView animateWithDuration:transitionDuration animations:^{
                fromView.frame = CGRectOffset(fromView.frame, 0.f, kScreenWidth);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }];
    }
    return self;
}

@end

@implementation SLPercentDrivenInteractiveTransition
- (void)presentedController:(UIViewController *)presentedController {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]init];
    WeakSelf;
    __weak typeof (presentedController) weakPresentController = presentedController;
    [gesture on:self click:^(UIGestureRecognizer * _Nonnull ges) {
        __strong typeof (presentedController) strongPresentController = weakPresentController;
        CGPoint transitionPoint = [gesture translationInView:strongPresentController.view];
        StrongSelf;
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:
            {
                strongSelf.isInteractive = YES;
                [strongPresentController dismissViewControllerAnimated:YES completion:nil];
            }
                break;
            case UIGestureRecognizerStateChanged:
            {
                CGFloat ratio = transitionPoint.y*1.0/kScreenHeight;
                if (ratio >= 0.3) {
                    strongSelf.shouldComplete = YES;
                } else {
                    strongSelf.shouldComplete = NO;
                }
                [strongSelf updateInteractiveTransition:ratio];
            }
                break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                if (strongSelf.shouldComplete) {
                    [strongSelf finishInteractiveTransition];
                } else {
                    [strongSelf cancelInteractiveTransition];
                }
                strongSelf.isInteractive = NO;
            }
                break;
            default:
                break;
        }
    }];
    [presentedController.view addGestureRecognizer:gesture];
}
@end

@implementation UIViewController (SLBase)
@dynamic interactiveTransition;
+ (UIViewController *)sl_getRootViewController{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController *)sl_getCurrentViewController:(UIViewController *)currentViewController{
    if ([currentViewController presentedViewController]) {
        UIViewController *nextRootVC = [currentViewController presentedViewController];
        currentViewController = [self sl_getCurrentViewController:nextRootVC];
    } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *nextRootVC = [(UITabBarController *)currentViewController selectedViewController];
        currentViewController = [self sl_getCurrentViewController:nextRootVC];
    } else if ([currentViewController isKindOfClass:[UINavigationController class]]){
        UIViewController *nextRootVC = [(UINavigationController *)currentViewController visibleViewController];
        currentViewController = [self sl_getCurrentViewController:nextRootVC];
    }
    return currentViewController;
}
+ (UIViewController *)sl_getCurrentViewController {
    return [self sl_getCurrentViewController:[self sl_getRootViewController]];
}

+ (UIViewController *)sl_getPresentingViewController {
    UIViewController *controller = [self sl_getCurrentViewController];
    if ([controller presentedViewController]) {
        while(controller.presentingViewController != nil){
            controller = controller.presentingViewController;
        }
        return controller;
    }
    return nil;
}

- (void)sl_setNavbarHidden:(BOOL)hidden {
    if ([self presentedViewController]) return;
    self.navigationController.navigationBarHidden = hidden;
}

- (void)sl_hiddenNavbar {
    if ([self presentedViewController]) return;
    [self sl_hiddenNavbarPreDeal];
    [self sl_setNavbarHidden:YES];
}

- (void)sl_showNavbar {
    if ([self presentedViewController]) return;
    [self sl_hiddenNavbarPreDeal];
    [self sl_setNavbarHidden:NO];
}

- (void)sl_hiddenNavbarPreDeal {
    [self swizzMethod:self action:WillDisappear callback:^(NSObject *__unsafe_unretained  _Nonnull obj) {
        if (![obj isKindOfClass:[UIViewController class]]) return;
        UIViewController *currentVc = (UIViewController *)obj;
        [currentVc sl_setNavbarHidden:NO];
    }];
}

- (void)sl_setTranslucent:(BOOL)translucent {
    if ([self presentedViewController]) return;
    self.navigationController.navigationBar.translucent = translucent;
}

- (void)sl_scrollToTranslucent {
    if ([self presentedViewController]) return;
    [self sl_scrollToTranslucentPreDeal];
    [self sl_setTranslucent:YES];
}

- (void)sl_scrollToTranslucentPreDeal {
    [self swizzMethod:self action:WillDisappear callback:^(NSObject *__unsafe_unretained  _Nonnull obj) {
        if (![obj isKindOfClass:[UIViewController class]]) return;
        UIViewController *currentVc = (UIViewController *)obj;
        [currentVc sl_setTranslucent:NO];
        [currentVc.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }];
}

- (void)sl_scrollToTranslucentWithAlpha:(CGFloat)alpha {
    if ([self presentedViewController]) return;
    if (alpha >= 1) {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        return;
    }
    UIColor *alphaColor = [UIColor colorWithWhite:1 alpha:alpha];
    UIImage *alphaImage = [UIImage sl_imageWithColor:alphaColor];
    [self.navigationController.navigationBar setBackgroundImage:alphaImage forBarMetrics:UIBarMetricsDefault];
}

- (void)sl_addPresentTrasition:(UIViewController *)presentController {
    WeakSelf;
    [self.interactiveTransition presentedController:presentController];
    [self addPresentedController:presentController];
    [self presentingControllerBlock:^id<UIViewControllerAnimatedTransitioning> _Nonnull(UIViewController * _Nonnull presentingController, UIViewController * _Nonnull sourceController) {
        return (id<UIViewControllerAnimatedTransitioning>)[[SLPresentTransitionAnimation alloc]init];
    }];
    [self dismissedControllerBlock:^id<UIViewControllerAnimatedTransitioning> _Nonnull(UIViewController * _Nonnull dismissedController) {
        return (id<UIViewControllerAnimatedTransitioning>)[[SLDissmissTransitionAnimation alloc]init];
    }];
    [self interactionDismissedControllerBlock:^id<UIViewControllerInteractiveTransitioning> _Nonnull(id<UIViewControllerAnimatedTransitioning>  _Nonnull animator) {
        StrongSelf;
        return strongSelf.interactiveTransition.isInteractive?strongSelf.interactiveTransition:nil;
    }];
}

- (SLPercentDrivenInteractiveTransition *)interactiveTransition {
    SLPercentDrivenInteractiveTransition *interactiveTransition = objc_getAssociatedObject(self, _cmd);
    if (!interactiveTransition) {
        interactiveTransition = [[SLPercentDrivenInteractiveTransition alloc]init];
        objc_setAssociatedObject(self, _cmd, interactiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return interactiveTransition;
}
@end
