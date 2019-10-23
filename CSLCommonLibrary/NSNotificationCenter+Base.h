//
//  NSNotificationCenter+Base.h
//  ReactiveCocoa
//
//  Created by SZDT00135 on 2019/10/21.
//  Copyright © 2019 SZDT00135. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NotificationReturnBlock) (NSNotification *data);
@interface NSNotificationCenter (Base)

- (void)addTarget:(NSObject *)target noidtificationName:(NSString *)notificationName object:(id)object block:(NotificationReturnBlock)block;
@end

NS_ASSUME_NONNULL_END
