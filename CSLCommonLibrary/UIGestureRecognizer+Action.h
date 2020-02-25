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
- (void)gestureRecognizerShouldBeginBlock:(BOOL(^)(UIGestureRecognizer *gesture))gestureRecognizerShouldBegin;
- (void)shouldRequireFailureOfGestureRecognizerBlock:(BOOL(^)(UIGestureRecognizer *gestureRecognizer,UIGestureRecognizer *otherGestureRecognizer))shouldRequireFailureOfGestureRecognizer;
- (void)gestureRecognizerShouldReceiveTouchBlock:(BOOL(^)(UIGestureRecognizer *gestureRecognizer,UITouch *touch))gestureRecognizerShouldReceiveTouch;
@end

NS_ASSUME_NONNULL_END
