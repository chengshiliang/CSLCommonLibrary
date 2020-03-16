//
//  SLUtil.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import "SLUtil.h"
#import <CSLCommonLibrary/UIViewController+SLBase.h>
#import <sys/utsname.h>

@implementation SLUtil

+ (NSString *)iphoneName {
    return [UIDevice currentDevice].name;
}

+ (NSString *)iphoneSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)bundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)bundleShortVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10.4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS MAX";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS MAX";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad AIR 2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad AIR 2";
    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad PRO 9.7";
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad PRO 9.7";
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad PRO 12.9";
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad PRO 12.9";
    if ([platform isEqualToString:@"iPad6,11"]) return @"iPad 5th generation";
    if ([platform isEqualToString:@"iPad6,12"]) return @"iPad 5th generation";
    if ([platform isEqualToString:@"iPad7,1"]) return @"iPad PRO 12.9 2nd Gen";
    if ([platform isEqualToString:@"iPad7,2"]) return @"iPad PRO 12.9 2nd Gen";
    if ([platform isEqualToString:@"iPad7,3"]) return @"iPad PRO 10.5";
    if ([platform isEqualToString:@"iPad7,4"]) return @"iPad PRO 10.5";
    return platform;
}

+ (BOOL)isIPhoneXSeries{
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}

+ (BOOL)bangsScreen {
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom;
        if (bottomSafeInset > 0) {
            return YES;
        }
    }
    return NO;
}

+ (void)runInMain:(void (^)(void))block {
    if ([[NSThread currentThread] isMainThread]) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (void)runBackground:(void (^)(void))block {
    if ([[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_global_queue(0, 0), block);
    }else {
        block();
    }
}

+ (void)setStatusBarIsHidden:(BOOL)isHidden{
    [[UIApplication sharedApplication]setStatusBarHidden:isHidden withAnimation:NO];
    UIViewController *controller=[UIViewController sl_getCurrentViewController];
    [controller prefersStatusBarHidden];
    [controller setNeedsStatusBarAppearanceUpdate];
}

+ (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    [[UIApplication sharedApplication]setStatusBarStyle:statusBarStyle];
    UIViewController *controller=[UIViewController sl_getCurrentViewController];
    [controller setNeedsStatusBarAppearanceUpdate];
}

+ (UIView *)duplicateComponent:(UIView *)view {
    if(view==nil) return nil;
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}
@end
