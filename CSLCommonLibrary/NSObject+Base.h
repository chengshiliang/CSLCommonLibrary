//
//  NSObject+Base.h
//  ReactiveCocoa
//
//  Created by SZDT00135 on 2019/10/22.
//  Copyright © 2019 SZDT00135. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Base)
- (void)swizzDeallocMethod:(NSObject *)target callback:(void(^)(__unsafe_unretained NSObject *deallocObj))callback;
- (void)swizzDisappearMethod:(NSObject *)target callback:(void(^)(__unsafe_unretained NSObject *disappearObj))callback;
- (void)addSelector:(SEL)selector fromProtocol:(_Nullable id)protocol callback:(void(^)(id))callback;
@end

NS_ASSUME_NONNULL_END
