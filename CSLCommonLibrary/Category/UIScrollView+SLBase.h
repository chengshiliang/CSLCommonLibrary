//
//  UIScrollView+SLBase.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (SLBase)
@property (readonly, nonatomic) UIEdgeInsets sl_inset;

@property (assign, nonatomic) CGFloat sl_insetTop;
@property (assign, nonatomic) CGFloat sl_insetBottom;
@property (assign, nonatomic) CGFloat sl_insetLeft;
@property (assign, nonatomic) CGFloat sl_insetRight;

@property (assign, nonatomic) CGFloat sl_offsetX;
@property (assign, nonatomic) CGFloat sl_offsetY;

@property (assign, nonatomic) CGFloat sl_contentWidth;
@property (assign, nonatomic) CGFloat sl_contentHeight;
@end

NS_ASSUME_NONNULL_END
