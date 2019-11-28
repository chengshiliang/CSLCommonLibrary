//
//  BaseObserver.m
//  ReactiveCocoa
//
//  Created by SZDT00135 on 2019/10/18.
//  Copyright © 2019 SZDT00135. All rights reserved.
//

#import "BaseObserver.h"

#import "NSObject+Base.h"

#import "KVOProxy.h"

@interface BaseObserver()
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) ObserverReturnBlock block;
@property (nonatomic, weak) NSObject *target;
@end
@implementation BaseObserver
- (instancetype)initWithTarget:(NSObject *)target keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(ObserverReturnBlock)block {
    if (self == [super init]) {
        self.keyPath = [keyPath copy];
        self.block = [block copy];
        self.target = target;
        [[KVOProxy share]addObserver:self];
        [self.target addObserver:[KVOProxy share] forKeyPath:self.keyPath options:options context:NULL];
        __weak __typeof(self)weakSelf = self;
        [self swizzMethod:target action:Dealloc callback:^(NSObject *__unsafe_unretained  _Nonnull obj) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSString *keyPath = strongSelf.keyPath;
            @synchronized (strongSelf) {
                strongSelf.block = nil;
                strongSelf.target = nil;
                strongSelf.keyPath = nil;
            }
            [obj removeObserver:[KVOProxy share] forKeyPath:keyPath context:NULL];
            [[KVOProxy share]removeObserver:strongSelf];
        }];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    ObserverReturnBlock block;
    id target;
    @synchronized (self) {
        block = self.block;
        target = self.target;
    }
    if (block == nil || target == nil) return;
    block(target, change);
}

- (void)dealloc{
    NSLog(@"base observer dealloc");
}
@end
