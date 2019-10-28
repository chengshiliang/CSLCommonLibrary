//
//  UIActionSheet+DeleteProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIActionSheet (DelegateProxy)
- (void)buttonClicked:(void(^)(UIActionSheet *actionSheet, int clickIndex))clickBlock;
- (void)cancel:(void(^)(UIActionSheet *actionSheet))cancelBlock;
- (void)willPresent:(void(^)(UIActionSheet *actionSheet))willPresentBlock;
- (void)didPresent:(void(^)(UIActionSheet *actionSheet))didPresentBlock;
- (void)willDismiss:(void(^)(UIActionSheet *actionSheet, int clickIndex))willDismissBlock;
- (void)didDismiss:(void(^)(UIActionSheet *actionSheet, int clickIndex))didDismissBlock;
@end

NS_ASSUME_NONNULL_END
