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
+ (instancetype)sl_timerWithTimeInterval:(NSTimeInterval)timeInterval
                                  target:(id)aTarget
                                userInfo:(nullable id)userInfo
                                 repeats:(BOOL)repeat
                                    mode:(NSRunLoopMode)mode
                                callback:(void(^)(NSArray *array))timerCallback {
    NSCParameterAssert(aTarget != NULL);
    if (timeInterval <= 0) {
        timeInterval = 1;
    }
    #pragma clang diagnostic push
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
        SEL aSelector = @selector(SLTimerSelector:);
    #pragma clang diagnostic pop

    TimerProxy *proxy = [TimerProxy proxyWithWeakObject:aTarget
                                               selector:aSelector
                                               callback:timerCallback];
    SLTimer *timer = (SLTimer *)[NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                      target:proxy
                                                    selector:aSelector
                                                    userInfo:userInfo
                                                     repeats:repeat];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:mode];
    __weak __typeof(timer)weakSelf = timer;
    [self swizzMethod:aTarget action:Dealloc callback:^(NSObject *__unsafe_unretained  _Nonnull obj) {
        __strong __typeof(timer)strongSelf = weakSelf;
        [strongSelf invalidate];
    }];
    return timer;
}
@end
