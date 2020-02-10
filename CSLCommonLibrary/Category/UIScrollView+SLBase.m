//
//  UIScrollView+SLBase.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "UIScrollView+SLBase.h"

@implementation UIScrollView (SLBase)
- (UIEdgeInsets)sl_inset {
    UIEdgeInsets insets = self.contentInset;
    if (@available(iOS 11, *)) {
        insets = self.adjustedContentInset;
    }
    return insets;
}

- (void)setSl_insetTop:(CGFloat)sl_insetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = sl_insetTop;
    if (@available(iOS 11, *)) {
        inset.top -= self.safeAreaInsets.top;
    }
    self.contentInset = inset;
}

- (CGFloat)sl_insetTop {
    return self.sl_inset.top;
}

- (void)setSl_insetBottom:(CGFloat)sl_insetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = sl_insetBottom;
    if (@available(iOS 11, *)) {
        inset.bottom -= self.safeAreaInsets.bottom;
    }
    self.contentInset = inset;
}

- (CGFloat)sl_insetBottom {
    return self.sl_inset.bottom;
}

- (void)setSl_insetLeft:(CGFloat)sl_insetLeft {
    UIEdgeInsets inset = self.contentInset;
    inset.left = sl_insetLeft;
    if (@available(iOS 11, *)) {
        inset.left -= self.safeAreaInsets.left;
    }
    self.contentInset = inset;
}

- (CGFloat)sl_insetLeft {
    return self.sl_inset.left;
}

- (void)setSl_insetRight:(CGFloat)sl_insetRight {
    UIEdgeInsets inset = self.contentInset;
    inset.right = sl_insetRight;
    if (@available(iOS 11, *)) {
        inset.right -= self.safeAreaInsets.right;
    }
    self.contentInset = inset;
}

- (CGFloat)sl_insetRight {
    return self.sl_inset.right;
}

- (void)setSl_offsetX:(CGFloat)sl_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = sl_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)sl_offsetX {
    return self.contentOffset.x;
}

- (void)setSl_offsetY:(CGFloat)sl_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = sl_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)sl_offsetY {
    return self.contentOffset.y;
}

- (void)setSl_contentWidth:(CGFloat)sl_contentWidth {
    CGSize size = self.contentSize;
    size.width = sl_contentWidth;
    self.contentSize = size;
}

- (CGFloat)sl_contentWidth {
    return self.contentSize.width;
}

- (void)setSl_contentHeight:(CGFloat)sl_contentHeight {
    CGSize size = self.contentSize;
    size.height = sl_contentHeight;
    self.contentSize = size;
}

- (CGFloat)sl_contentHeight {
    return self.contentSize.height;
}
@end
