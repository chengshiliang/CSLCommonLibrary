//
//  UIImage+SLBase.h
//  CSLUILibrary
//
//  Created by 程筱 on 2019/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SLBase)
+ (UIImage *)decodeImage:(UIImage *)image toSize:(CGSize)size;

+ (UIImage *)sl_imageWithColor:(UIColor *)color;

+ (UIImage *)sl_imageWithGifName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
