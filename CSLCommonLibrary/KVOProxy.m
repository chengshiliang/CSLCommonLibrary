//
//  KVOProxy.m
//  ReactiveCocoa
//
//  Created by SZDT00135 on 2019/10/18.
//  Copyright © 2019 SZDT00135. All rights reserved.
//

#import "KVOProxy.h"

@interface KVOProxy()
{
    NSMutableArray *_kvoer;
    dispatch_queue_t _queue;
}
@end

@implementation KVOProxy

+ (instancetype)share{
    static KVOProxy *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KVOProxy alloc]init];
    });
    return instance;
}

- (instancetype)init {
    if (self == [super init]) {
        _kvoer = [NSMutableArray array];
        _queue = dispatch_queue_create("com.slc.kvoproxy", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)addObserver:(__weak NSObject *)observer {
    __block NSMutableArray *arrM = _kvoer;
    dispatch_sync(_queue, ^{
        if (![arrM containsObject:observer]) {
            [arrM addObject:observer];
        }
    });
}

- (void)removeObserver:(__weak NSObject *)observer {
    __block NSMutableArray *arrM = _kvoer;
    dispatch_sync(_queue, ^{
        if ([arrM containsObject:observer]) {
            [arrM removeObject:observer];
        }
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (change[@"new"]) {
        __block NSMutableArray *arrM = _kvoer;
        dispatch_sync(_queue, ^{
            for (NSObject * observer in arrM) {
                if (observer != nil) {
                    [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
                }
            }
        });
    }
}
@end
