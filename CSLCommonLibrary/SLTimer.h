//
//  SLTimer.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTimer : NSTimer
+ (NSTimer *)sl_timerWithTimeInterval:(NSTimeInterval)timeInterval
                                  target:(id)aTarget
                                userInfo:(nullable id)userInfo
                                 repeats:(BOOL)repeat
                                    mode:(NSRunLoopMode)mode
                                callback:(void(^)(NSArray *array))timerCallback;
@end

NS_ASSUME_NONNULL_END
