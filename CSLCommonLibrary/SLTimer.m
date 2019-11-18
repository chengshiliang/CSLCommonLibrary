//
//  SLTimer.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import "SLTimer.h"
#import "TimerProxy.h"
#import "NSObject+Base.h"

@implementation SLTimer
+ (NSTimer *)sl_timerWithTimeInterval:(NSTimeInterval)timeInterval
                                  target:(id)aTarget
                                userInfo:(nullable id)userInfo
                                 repeats:(BOOL)repeat
                                    mode:(NSRunLoopMode)mode
                                callback:(void(^)(NSArray *array))timerCallback {
    return [[self alloc]sl_timerWithTimeInterval:timeInterval
                                          target:aTarget
                                        userInfo:userInfo
                                         repeats:repeat
                                            mode:mode
                                        callback:timerCallback];
}

- (NSTimer *)sl_timerWithTimeInterval:(NSTimeInterval)timeInterval
                                  target:(id)aTarget
                                userInfo:(nullable id)userInfo
                                 repeats:(BOOL)repeat
                                    mode:(NSRunLoopMode)mode
                                callback:(void(^)(NSArray *array))timerCallback {
    NSCParameterAssert(aTarget != NULL);
    if (timeInterval <= 0) {
        timeInterval = 1;
    }
    __weak __typeof(self)weakSelf = self;
    [self swizzDeallocMethod:aTarget callback:^(NSObject * _Nonnull __unsafe_unretained deallocObj) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf invalidate];
    }];

#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    SEL aSelector = @selector(SLTimerSelector:);
#pragma clang diagnostic pop

    TimerProxy *proxy = [TimerProxy proxyWithWeakObject:aTarget
                                               selector:aSelector
                                               callback:timerCallback];
    if (mode == NSRunLoopCommonModes) {
        return [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                target:proxy
                                              selector:aSelector
                                              userInfo:userInfo
                                               repeats:repeat];
    } else {
        NSTimer *timer = [NSTimer timerWithTimeInterval:timeInterval
                                                 target:proxy
                                               selector:aSelector
                                               userInfo:userInfo
                                                repeats:repeat];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:mode];
        return timer;
    }
}
@end
