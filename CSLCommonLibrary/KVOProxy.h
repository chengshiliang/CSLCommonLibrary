//
//  KVOProxy.h
//  ReactiveCocoa
//
//  Created by SZDT00135 on 2019/10/18.
//  Copyright © 2019 SZDT00135. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVOProxy : NSObject
+ (instancetype)share;
- (void)addObserver:(__weak NSObject *)observer;
- (void)removeObserver:(__weak NSObject *)observer;
@end

NS_ASSUME_NONNULL_END
