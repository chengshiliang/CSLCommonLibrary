//
//  UIAlertView+DelegateProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertView (DelegateProxy)
- (void)buttonClicked:(void(^)(UIAlertView *actionView, int clickIndex))clickBlock;
- (void)cancel:(void(^)(UIAlertView *actionView))cancelBlock;
- (void)willPresent:(void(^)(UIAlertView *actionView))willPresentBlock;
- (void)didPresent:(void(^)(UIAlertView *actionView))didPresentBlock;
- (void)willDismiss:(void(^)(UIAlertView *actionView, int clickIndex))willDismissBlock;
- (void)didDismiss:(void(^)(UIAlertView *actionView, int clickIndex))didDismissBlock;
- (void)enableFirstOtherButton:(BOOL(^)(UIAlertView *actionView))enableFirstOtherButtonBlock;
@end

NS_ASSUME_NONNULL_END
