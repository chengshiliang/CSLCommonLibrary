//
//  NSObject+Base.h
//  ReactiveCocoa
//
//  Created by SZDT00135 on 2019/10/22.
//  Copyright © 2019 SZDT00135. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SwizzActionType) {
    Dealloc = 1,
    DidLoad = 2,
    WillAppear = 3,
    DidAppear = 4,
    WillDisappear = 5,
    DidDisappear = 6
};

@interface NSObject (Base)
- (void)swizzMethod:(NSObject *)target action:(SwizzActionType)type callback:(void(^)(__unsafe_unretained NSObject *obj))callback;
- (void)addSelector:(SEL)selector fromProtocol:(_Nullable id)protocol callback:(void(^)(id))callback;
@end

NS_ASSUME_NONNULL_END
