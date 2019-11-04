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
@end

NS_ASSUME_NONNULL_END
