//
//  CSLBaseObject.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSLBaseObject : NSObject
+ (id)invokeArguments:(NSArray *)args withBlock:(id)block;
@end

NS_ASSUME_NONNULL_END
