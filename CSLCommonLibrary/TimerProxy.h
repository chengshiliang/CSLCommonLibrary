//
//  TimerProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerProxy : NSObject
+ (instancetype)proxyWithWeakObject:(id)obj selector:(SEL)aSelector callback:(void(^)(NSArray *array))timerCallback;
@end

NS_ASSUME_NONNULL_END
