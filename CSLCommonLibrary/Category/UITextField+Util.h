//
//  UITextField+Util.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Util)
/**
 *  关闭emoji
 */
-(void)disableEmoji;

//最大长度
-(void)maxLength:(NSInteger)length;
@end

NS_ASSUME_NONNULL_END
