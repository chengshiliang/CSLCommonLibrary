//
//  UIControl+Events.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/29.
//

#import "UIControl+Events.h"
#import "NSObject+Base.h"
#import <objc/runtime.h>

static void *kControl_Key = "kControl_Key";
static void *kControl_EventIntervalKey = "kControl_EventIntervalKey";
static void *kControl_LastEventTimeKey = "kControl_LastEventTimeKey";

@implementation UIControl (Events)
- (NSTimeInterval)eventInterval {
    NSNumber *intervalNum = objc_getAssociatedObject(self, kControl_EventIntervalKey);
    if (!intervalNum) {
        [self setEventInterval:1.0];
    }
    return [intervalNum doubleValue];
}

- (void)setEventInterval:(NSTimeInterval)eventInterval {
    objc_setAssociatedObject(self, kControl_EventIntervalKey, @(eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)lastEventTime {
    return  [objc_getAssociatedObject(self, kControl_LastEventTimeKey) doubleValue];
}

- (void)setLastEventTime:(NSTimeInterval)lastEventTime {
    objc_setAssociatedObject(self, kControl_LastEventTimeKey, @(lastEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)onEventChange:(NSObject *)target event:(UIControlEvents)event change:(void(^)(UIControl *control))changeBlock{
    [self addTarget:self action:@selector(eventChange:) forControlEvents:event];
    [self setChangeBlock:changeBlock];
    __weak __typeof(self)weakSelf = self;
    [self swizzMethod:target action:Dealloc callback:^(NSObject *__unsafe_unretained  _Nonnull obj) {
        __strong __typeof(self)strongSelf = weakSelf;
        [strongSelf removeTarget:strongSelf action:@selector(eventChange:) forControlEvents:event];
    }];
}

- (void)setChangeBlock:(void (^)(UIControl *))changeBlock {
    objc_setAssociatedObject(self, kControl_Key, changeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIControl *))changeBlock {
    return objc_getAssociatedObject(self, kControl_Key);
}

- (void)eventChange:(UIControl *)control {
    if ([NSDate date].timeIntervalSince1970 - self.lastEventTime < self.eventInterval) return;
    if (self.eventInterval > 0) {
        self.lastEventTime = [NSDate date].timeIntervalSince1970;
    }
    if (self.changeBlock) {
        self.changeBlock(control);
    }
}

//- (void)dealloc {
//    NSLog(@"control dealloc");
//}
@end
