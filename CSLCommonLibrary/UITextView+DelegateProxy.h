//
//  UIAlertView+DelegateProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (DelegateProxy)
- (void)didBeginEditing:(void(^)(UITextView *textView))didBeginEditingBlock;
- (void)didEndEditing:(void(^)(UITextView *textView))didEndEditingBlock;
- (void)didChange:(void(^)(UITextView *textView))didChangeBlock;
- (void)didChangeSelection:(void(^)(UITextView *textView))didChangeSelectionBlock;
- (void)shouldBeginEditing:(BOOL(^)(UITextView *textView))shouldBeginEditingBlock;
- (void)shouldEndEditing:(BOOL(^)(UITextView *textView))shouldEndEditingBlock;
- (void)shouldChangeTextInRange:(BOOL(^)(UITextView *textView,NSRange range,NSString *text))shouldChangeTextInRangeBlock;
- (void)shouldInteractWithURL:(BOOL(^)(UITextView *textView,NSURL* URL,NSRange characterRange,UITextItemInteraction interaction))shouldInteractWithURLBlock NS_AVAILABLE_IOS(10_0);
- (void)shouldInteractWithTextAttachment:(BOOL(^)(UITextView *textView,NSTextAttachment * textAttachment,NSRange characterRange,UITextItemInteraction interaction))shouldInteractWithTextAttachmentBlock NS_AVAILABLE_IOS(10_0);
- (void)shouldInteractWithURLOld:(BOOL(^)(UITextView *textView,NSURL* URL,NSRange characterRange))shouldInteractWithURLBlock NS_DEPRECATED_IOS(7_0, 10_0, "use shouldInteractWithURL instead");
- (void)shouldInteractWithTextAttachmentOld:(BOOL(^)(UITextView *textView,NSTextAttachment * textAttachment,NSRange characterRange))shouldInteractWithTextAttachmentBlock NS_DEPRECATED_IOS(7_0, 10_0, "Use shouldInteractWithTextAttachment instead");
@end

NS_ASSUME_NONNULL_END
