//
//  CSLDelegateProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSLDelegateProxy : NSObject
@property (nonatomic, weak) id delegate;
- (instancetype)initWithDelegateProxy:(Protocol *)protocol;
- (void)addSelector:(SEL)selector callback:(void(^)(id))callback;
@end

NS_ASSUME_NONNULL_END
