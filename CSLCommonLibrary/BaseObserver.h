//
//  BaseObserver.h
//  ReactiveCocoa
//
//  Created by SZDT00135 on 2019/10/18.
//  Copyright © 2019 SZDT00135. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ObserverReturnBlock) (id target, NSDictionary *change);
@interface BaseObserver : NSObject
- (instancetype)initWithTarget:(NSObject *)target keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(ObserverReturnBlock)block;
@end

NS_ASSUME_NONNULL_END
