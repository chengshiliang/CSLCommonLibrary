//
//  UIAlertView+DelegateProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertView (DelegateProxy)
- (void)buttonClicked:(void(^)(UIAlertView *alertView, int clickIndex))clickBlock;
- (void)cancel:(void(^)(UIAlertView *alertView))cancelBlock;
- (void)willPresent:(void(^)(UIAlertView *alertView))willPresentBlock;
- (void)didPresent:(void(^)(UIAlertView *alertView))didPresentBlock;
- (void)willDismiss:(void(^)(UIAlertView *alertView, int clickIndex))willDismissBlock;
- (void)didDismiss:(void(^)(UIAlertView *alertView, int clickIndex))didDismissBlock;
- (void)shouldEnableFirstOtherButton:(BOOL (^)(UIAlertView* alerView))shouldEnableFirstOtherButtonBlock;
@end

NS_ASSUME_NONNULL_END
