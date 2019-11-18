//
//  TimerProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import "TimerProxy.h"
#import "NSObject+Base.h"

@interface TimerProxy()
@property (weak, nonatomic) id weakObject;
@end

@implementation TimerProxy
- (instancetype)initWithWeakObject:(id)obj
                          selector:(SEL)aSelector
                          callback:(void(^)(NSArray *array))timerCallback {
    self.weakObject = obj;
    [self addSelector:aSelector
         fromProtocol:NULL
             callback:timerCallback];
    return self;
}

+ (instancetype)proxyWithWeakObject:(id)obj
                           selector:(SEL)aSelector
                           callback:(void(^)(NSArray *array))timerCallback {
    return [[TimerProxy alloc] initWithWeakObject:obj selector:aSelector callback:timerCallback];
}
@end
