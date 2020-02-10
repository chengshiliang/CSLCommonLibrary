//
//  NSData+Util.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Util)
+ (NSString *)sl_base64EncodedString:(NSData *)originData;
@end

NS_ASSUME_NONNULL_END
