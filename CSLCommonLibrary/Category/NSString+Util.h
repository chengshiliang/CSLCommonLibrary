//
//  NSString+Util.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Util)

NS_ASSUME_NONNULL_BEGIN

+ (BOOL)emptyString:(NSString *)str;
+ (NSString *)blankString:(NSString *)str;
- (CGSize)sizeWithFont:(UIFont*)font size:(CGSize)size;
- (CGFloat)heightWithFont:(UIFont*)font width:(CGFloat)width;
- (CGFloat)widthWithFont:(UIFont*)font height:(CGFloat)height;
- (NSUInteger)compareTo:(NSString*)comp;
- (NSUInteger)compareToIgnoreCase:(NSString*) comp;
- (bool)contains:(NSString*)substring;
- (bool)endsWith:(NSString*)substring;
- (bool)startsWith:(NSString*)substring;
- (NSUInteger)indexOf:(NSString*)substring;
- (NSUInteger)indexOf:(NSString *)substring startingFrom:(NSUInteger)index;
- (NSUInteger)lastIndexOf:(NSString*)substring;
- (NSUInteger)lastIndexOf:(NSString *)substring startingFrom:(NSUInteger)index;
- (NSString*)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
- (NSString*)trim;
- (NSArray*)split:(NSString*)token;
- (NSString*)replace:(NSString*) target withString:(NSString*)replacement;
- (NSArray*)split:(NSString*)token limit:(NSUInteger)maxResults;

+ (NSString *)sl_md5String:(NSString *)string;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;//手机号验证

+ (BOOL)isValidEmail:(NSString *)emailStr;//检查邮箱是否有效

+ (BOOL)isValidPassword:(NSString *)passwordStr;//检查密码格式是否正确

+ (BOOL)isContainsEmoji:(NSString *)string;//检查时候包含emoji

+ (NSString *)removeEmojiString:(NSString *)string;//去除emoji

- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;
- (CGSize)sizeWithConstrainedToSize:(CGSize)size fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;
/**
 利用CoreText进行文字的绘制
 */
- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height andWidth:(float)width;
- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height;
@end

NS_ASSUME_NONNULL_END
