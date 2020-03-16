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
/**
DeviceInfo：获取当前设备的 用户自定义的别名，例如：库克的 iPhone 9

@return 当前设备的 用户自定义的别名，例如：库克的 iPhone 9
*/
+ (NSString *)iphoneName;

/**
 DeviceInfo：获取当前设备的 系统名称，例如：iOS 13.1
 
 @return 当前设备的 系统名称，例如：iOS 13.1
 */
+ (NSString *)iphoneSystemVersion;

+ (NSString *)bundleIdentifier;

+ (NSString *)bundleVersion;

+ (NSString *)bundleShortVersionString;

+ (NSString *)iphoneType;

+ (BOOL)isIPhoneXSeries;
@end

NS_ASSUME_NONNULL_END
