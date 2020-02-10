//
//  UIViewController+SLBase.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface SLPresentTransitionAnimation : NSObject

@end

@interface SLDissmissTransitionAnimation : NSObject

@end

@interface SLPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition
@property(nonatomic, assign)BOOL isInteractive;
@property(nonatomic, assign) BOOL shouldComplete;
- (void)presentedController:(UIViewController *)presentedController;
@end

@interface UIViewController (SLBase)
@property(nonatomic, strong) SLPercentDrivenInteractiveTransition *interactiveTransition;

+ (UIViewController *)sl_getRootViewController;
+ (UIViewController *)sl_getCurrentViewController:(UIViewController *)currentViewController;
+ (UIViewController *)sl_getCurrentViewController;
/*
 获取多次present出来最底层presenting的控制器
 */
+ (UIViewController *)sl_getPresentingViewController;

- (void)sl_setNavbarHidden:(BOOL)hidden;
// 隐藏导航栏
- (void)sl_hiddenNavbar;
// 显示导航栏
- (void)sl_showNavbar;

- (void)sl_setTranslucent:(BOOL)translucent;
/**
 页面滚动导航栏变透明
 */
- (void)sl_scrollToTranslucent;

- (void)sl_scrollToTranslucentWithAlpha:(CGFloat)alpha;

/**
 添加present和dismiss动画
 */
- (void)sl_addPresentTrasition:(UIViewController *)presentController;
@end

NS_ASSUME_NONNULL_END
