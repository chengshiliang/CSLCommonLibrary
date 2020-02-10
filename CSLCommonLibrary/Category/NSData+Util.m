//
//  NSData+Util.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/19.
//

#import "NSData+Util.h"

@implementation NSData (Util)
static const char sl_base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+ (NSString *)sl_base64EncodedString:(NSData *)originData {
    if (!originData) return @"";
    const uint8_t *input = originData.bytes;
    NSInteger length = originData.length;
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] = sl_base64EncodingTable[(value >> 18) & 0x3F];
        output[index + 1] = sl_base64EncodingTable[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? sl_base64EncodingTable[(value >> 6) & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? sl_base64EncodingTable[(value >> 0) & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
@end
