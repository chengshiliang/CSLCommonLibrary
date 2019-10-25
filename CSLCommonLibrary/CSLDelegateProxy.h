//
//  CSLDelegateProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSLDelegateProxy : NSProxy

- (instancetype)initWithDelegateProxy:(id)protocol;
@end

NS_ASSUME_NONNULL_END
