//
//  UIControl+Events.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Events)
@property (nonatomic, assign) NSTimeInterval eventInterval;// 事件点击间隔时间

- (void)onEventChange:(NSObject *)target event:(UIControlEvents)event change:(void(^)(UIControl *control))changeBlock;
@end

NS_ASSUME_NONNULL_END
