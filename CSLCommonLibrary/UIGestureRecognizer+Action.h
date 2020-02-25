//
//  UIGestureRecognizer+Action.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (Action)
- (void)on:(NSObject *)target click:(void(^)(UIGestureRecognizer *gesture))clickBlock;
- (void)gestureRecognizerShouldBeginBlock:(BOOL(^)(UIGestureRecognizer *gesture))gestureRecognizerShouldBeginBlock;
- (void)shouldRequireFailureOfGestureRecognizerBlock:(BOOL(^)(UIGestureRecognizer *gestureRecognizer,UIGestureRecognizer *otherGestureRecognizer))shouldRequireFailureOfGestureRecognizerBlock;
- (void)gestureRecognizerShouldReceiveTouchBlock:(BOOL(^)(UIGestureRecognizer *gestureRecognizer,UITouch *touch))gestureRecognizerShouldReceiveTouchBlock;
@end

NS_ASSUME_NONNULL_END
