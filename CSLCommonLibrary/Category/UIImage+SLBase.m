//
//  UIImage+SLBase.m
//  CSLUILibrary
//
//  Created by 程筱 on 2019/11/17.
//

#import "UIImage+SLBase.h"
#import <CSLCommonLibrary/NSString+Util.h>
#import <SDWebImage/SDWebImage.h>

@implementation UIImage (SLBase)
+ (UIImage *)decodeImage:(UIImage *)image toSize:(CGSize)size {
    if (image == nil) return nil;
    // animated images
    if (image.images != nil) return image;
    CGImageRef imageRef = image.CGImage;
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    BOOL anyAlpha = (alpha == kCGImageAlphaFirst ||
                     alpha == kCGImageAlphaLast ||
                     alpha == kCGImageAlphaPremultipliedFirst ||
                     alpha == kCGImageAlphaPremultipliedLast);
    if (anyAlpha) {
        NSLog(@"图片解压失败，存在alpha通道");
        return image;
    }
    CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
    CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
    BOOL unsupportedColorSpace = (imageColorSpaceModel == kCGColorSpaceModelUnknown ||
                                  imageColorSpaceModel == kCGColorSpaceModelMonochrome ||
                                  imageColorSpaceModel == kCGColorSpaceModelCMYK ||
                                  imageColorSpaceModel == kCGColorSpaceModelIndexed);
    if (unsupportedColorSpace) {
        colorspaceRef = CGColorSpaceCreateDeviceRGB();
    }
    size_t width = size.width;
    size_t height = size.height;
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorspaceRef,
                                                 kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
    UIImage *imageWithoutAlpha = [UIImage imageWithCGImage:imageRefWithoutAlpha
                                                     scale:image.scale
                                               orientation:image.imageOrientation];
    CGImageRelease(imageRefWithoutAlpha);
    CGColorSpaceRelease(colorspaceRef);
    CGContextRelease(context);
    return imageWithoutAlpha;
}

+ (UIImage *)sl_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)sl_imageWithGifName:(NSString *)name {
    if ([NSString emptyString:name]) return nil;
    NSArray *names = [name componentsSeparatedByString:@"."];
    if (names && names.count > 2) return nil;
    if (names && names.count > 1) {
        NSString *typeName = [names lastObject];
        if (![typeName isEqualToString:@"gif"]) {
            return nil;
        }
    } else {
        if (names) {
            name = [name stringByAppendingString:@".gif"];
        }
    }
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage sd_imageWithGIFData:imageData];// SDWebImage加载gif图片
    return image;
}
@end
