//
//  UIControl+Events.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Events)
- (void)onEventChange:(NSObject *)target event:(UIControlEvents)event change:(void(^)(UIControl *))changeBlock;
@end

NS_ASSUME_NONNULL_END
