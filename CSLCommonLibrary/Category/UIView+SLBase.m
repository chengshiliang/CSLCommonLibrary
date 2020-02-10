//
//  UIView+SLBase.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import "UIView+SLBase.h"
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLCommonLibrary/SLTimer.h>

@implementation UIView (SLBase)
- (CGFloat)sl_height
{
    return self.frame.size.height;
}

- (void)setSl_height:(CGFloat)sl_height
{
    CGRect temp = self.frame;
    temp.size.height = sl_height;
    self.frame = temp;
}

- (CGFloat)sl_width
{
    return self.frame.size.width;
}

- (void)setSl_width:(CGFloat)sl_width
{
    CGRect temp = self.frame;
    temp.size.width = sl_width;
    self.frame = temp;
}


- (CGFloat)sl_y
{
    return self.frame.origin.y;
}

- (void)setSl_y:(CGFloat)sl_y
{
    CGRect temp = self.frame;
    temp.origin.y = sl_y;
    self.frame = temp;
}

- (CGFloat)sl_x
{
    return self.frame.origin.x;
}

- (void)setSl_x:(CGFloat)sl_x
{
    CGRect temp = self.frame;
    temp.origin.x = sl_x;
    self.frame = temp;
}

- (CGFloat)sl_maxX {
    return [self sl_x]+[self sl_width];
}

- (void)setSl_maxX:(CGFloat)sl_maxX {
    self.sl_x = sl_maxX-self.sl_width;
}

- (CGFloat)sl_maxY {
    return [self sl_y]+[self sl_height];
}

- (void)setSl_maxY:(CGFloat)sl_maxY {
    self.sl_y = sl_maxY-self.sl_height;
}

- (void)sl_blurEffect {
    [self sl_blurEffect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)sl_blurEffectWithSyle:(EffectStyle)style {
    [self sl_blurEffect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:style];
}

- (void)sl_blurEffect:(CGRect)rect {
    [self sl_blurEffect:rect style:EffectStyleDefault];
}

- (void)sl_blurEffect:(CGRect)rect style:(EffectStyle)style {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:rect];
    switch (style) {
        case EffectStyleDefault:
            toolbar.barStyle = UIBarStyleDefault;
            break;
        case EffectStyleBlack:
            toolbar.barStyle = UIBarStyleBlack;
            break;
        case EffectStyleTranslucent:
            toolbar.barStyle = UIBarStyleBlack;
            toolbar.translucent = YES;
            break;
        default:
            break;
    }
    [self addSubview:toolbar];
}

- (void)addLoadingWithFillColor:(UIColor *)fillColor
                    strokeColor:(UIColor *)strokeColor
                   loadingColor:(UIColor *)loadingColor
                      lineWidth:(CGFloat)lineWidth
                       duration:(CGFloat)duration
                     startAngle:(CGFloat)startAngle{
    if (self.frame.size.width <=0 || self.frame.size.height <= 0) return;
    if (lineWidth <= 0) lineWidth = 1.0f;
    if (duration <= 5) duration = 5;
    if (!fillColor) fillColor = [UIColor clearColor];
    if (!strokeColor) strokeColor = SLUIHexColor(0xe0e0e0);
    if (!loadingColor) loadingColor = SLUIHexColor(0x398EEB);
    startAngle = startAngle * M_PI / 180.0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.layer removeAllAnimations];
    CGFloat radius = MIN(width/2.0, height/2.0) - lineWidth;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds), radius, radius);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    bezierPath.lineCapStyle = kCGLineCapButt;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = lineWidth;
    [self.layer addSublayer:shapeLayer];
    
    CAShapeLayer *loadingLayer = [CAShapeLayer layer];
    loadingLayer.frame = CGRectMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds), radius, radius);
    loadingLayer.fillColor = [UIColor clearColor].CGColor;
    loadingLayer.strokeColor = loadingColor.CGColor;
    loadingLayer.lineWidth = lineWidth;
    [self.layer addSublayer:loadingLayer];
    
    __block CGFloat progress = 0.0;
    [SLTimer sl_timerWithTimeInterval:duration/200.0 target:self userInfo:nil repeats:YES mode:NSRunLoopCommonModes callback:^(NSArray * _Nonnull array) {
        if (progress >= 1.0) progress = 0.0;
        else progress += 0.025;
        CGFloat angle = startAngle+progress*2*M_PI;
        UIBezierPath *loadingPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:angle endAngle:angle + M_PI_4 clockwise:YES];
        loadingPath.lineCapStyle = kCGLineCapSquare;
        loadingLayer.path = loadingPath.CGPath;
    }];
}

- (void)addCornerRadius:(CGFloat)cornerRadius
            shadowColor:(UIColor *)shadowColor
           shadowOffset:(CGSize)shadowOffset
          shadowOpacity:(CGFloat)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius {
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPathWithRoundedRect:CGRectOffset(self.bounds, shadowOffset.width, shadowOffset.height) cornerRadius:shadowRadius];
    self.layer.cornerRadius = cornerRadius;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowPath = bezierPath2.CGPath;
}

- (void)addCornerRadius:(CGFloat)cornerRadius
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor * _Nullable)borderColor
        backGroundColor:(UIColor * _Nullable)backColor
                offsetX:(CGFloat)offsetX
                offsetY:(CGFloat)offsetY
            cornersType:(UIRectCorner)corners {
    if (!backColor) {
        backColor = [UIColor clearColor];
    }
    if (!borderColor) {
        borderColor = [UIColor clearColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, backColor.CGColor);
    if (borderWidth > 0) {
        CGContextSetLineWidth(context, borderWidth);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    } else {
        CGContextSetLineWidth(context, 0.0);
        CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);
    }
    UIBezierPath *bezierPath;
    CGRect rect = CGRectInset(self.bounds, offsetX, offsetY);
    if (cornerRadius > 0) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:rect];
    }
    
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathFillStroke);

    self.layer.contents = (__bridge id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
}

- (void)addCornerRadius:(CGFloat)cornerRadius
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor
        backGroundColor:(UIColor *)backColor {
    [self addCornerRadius:cornerRadius
              borderWidth:borderWidth
              borderColor:borderColor
          backGroundColor:backColor
                  offsetX:borderWidth/2.0
                  offsetY:borderWidth/2.0
              cornersType:UIRectCornerAllCorners];
}

- (void)addCorner:(BOOL)corner {
    [self addCornerRadius:corner ? MIN(self.frame.size.width/2.0, self.frame.size.height/2.0) : 0];
}

- (void)addCornerRadius:(CGFloat)cornerRadius {
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = self.bounds;
    UIBezierPath *bezierPath;
    if (cornerRadius > 0) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    }
    shaperLayer.path = bezierPath.CGPath;
    self.layer.mask = shaperLayer;
}

+ (UIImage *)sl_renderViewToImage:(UIView *)view {
    if (!view) return nil;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIView *)copyView:(UIView *)view {
    if (!view) return nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
