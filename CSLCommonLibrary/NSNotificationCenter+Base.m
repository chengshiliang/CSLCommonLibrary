//
//  NSNotificationCenter+Base.m
//  ReactiveCocoa
//
//  Created by SZDT00135 on 2019/10/21.
//  Copyright © 2019 SZDT00135. All rights reserved.
//

#import "NSNotificationCenter+Base.h"
#import "NSObject+Base.h"
#import <objc/runtime.h>

static void *kNotification_Observer_Key = "kNotification_Observer_Key";

@implementation NSNotificationCenter (Base)
- (void)addTarget:(NSObject *)target noidtificationName:(NSString *)notificationName object:(id)object block:(NotificationReturnBlock)block {
    id <NSObject> observer = [self addObserverForName:notificationName object:object queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (block == nil) return;
        block(note);
    }];
    
    @synchronized (self) {
        if (!self.observers) {
            self.observers = [NSMutableDictionary dictionary];
        }
        if (!self.observers[target.description]) {
            self.observers[target.description] = observer;
        }
    }
    __weak __typeof(self)weakSelf = self;
    [self swizzMethod:target action:Dealloc callback:^(NSObject *__unsafe_unretained  _Nonnull obj) {
        __strong __typeof(self)strongSelf = weakSelf;
        id <NSObject> observer = strongSelf.observers[obj.description];
        if (observer) {
            [strongSelf removeObserver:observer];
        }
    }];
    
}

- (void)setObservers:(NSMutableDictionary *)observers {
    objc_setAssociatedObject(self, &kNotification_Observer_Key, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)observers {
    return objc_getAssociatedObject(self, &kNotification_Observer_Key);
}

- (void)dealloc {
    NSLog(@"notification dealloc");
}
@end
