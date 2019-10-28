//
//  CSLBaseControl.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ControlReturnBlock) (UIControl *control);
@interface CSLBaseControl : UIControl
- (instancetype)initWithTarget:(NSObject *)target controlEvent:(UIControlEvents)controlEvent block:(ControlReturnBlock)block;
@end

NS_ASSUME_NONNULL_END
