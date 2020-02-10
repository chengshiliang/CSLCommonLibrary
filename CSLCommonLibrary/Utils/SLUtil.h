//
//  SLUtil.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLUtil : NSObject
+ (BOOL)bangsScreen;
+ (void)runInMain:(void(^)(void))block;
+ (void)runBackground:(void(^)(void))block;
/**
 设置状态栏是否隐藏-info.plist UIViewControllerBasedStatusBarAppearance NO

 @param isHidden 是否隐藏
 */
+ (void)setStatusBarIsHidden:(BOOL)isHidden;

/**
 设置状态栏样式-info.plist UIViewControllerBasedStatusBarAppearance NO

 @param statusBarStyle 状态栏样式
 */
+ (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle;
/**
 复制view
 */
+ (UIView *)duplicateComponent:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
