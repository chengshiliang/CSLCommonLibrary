//
//  SLUtil.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import "SLUtil.h"
#import <CSLCommonLibrary/UIViewController+SLBase.h>

@implementation SLUtil

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
