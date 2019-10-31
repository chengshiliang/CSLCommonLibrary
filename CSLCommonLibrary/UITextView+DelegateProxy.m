//
//  UIAlertView+DelegateProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import "UITextView+DelegateProxy.h"
#import <objc/runtime.h>
#import "CSLDelegateProxy.h"

static void *kTextViewShouldBeginEditingKey = "kTextViewShouldBeginEditingKey";
static void *kTextViewShouldEndEditingKey = "kTextViewShouldEndEditingKey";
static void *kTextViewShouldChangeTextInRangeKey = "kTextViewShouldChangeTextInRangeKey";
static void *kTextViewShouldInteractWithURLKey = "kTextViewShouldInteractWithURLKey";
static void *kTextViewShouldInteractWithTextAttachmentKey = "kTextViewShouldInteractWithTextAttachmentKey";
static void *kTextViewShouldInteractWithURLOldKey = "kTextViewShouldInteractWithURLOldKey";
static void *kTextViewShouldInteractWithTextAttachmentOldKey = "kTextViewShouldInteractWithTextAttachmentOldKey";

@implementation UITextView (DelegateProxy)
- (void)didBeginEditing:(void(^)(UITextView *textView))didBeginEditingBlock {
    [self.delegateProxy addSelector:@selector(textViewDidBeginEditing:) callback:^(NSArray *params) {
        if (didBeginEditingBlock && params.count == 1) {
            didBeginEditingBlock(params[0]);
        }
    }];
}
- (void)didEndEditing:(void(^)(UITextView *textView))didEndEditingBlock{
    [self.delegateProxy addSelector:@selector(textViewDidEndEditing:) callback:^(NSArray *params) {
        if (didEndEditingBlock && params.count == 1) {
            didEndEditingBlock(params[0]);
        }
    }];
}
- (void)didChange:(void(^)(UITextView *textView))didChangeBlock{
    [self.delegateProxy addSelector:@selector(textViewDidChange:) callback:^(NSArray *params) {
        if (didChangeBlock && params.count == 1) {
            didChangeBlock(params[0]);
        }
    }];
}
- (void)didChangeSelection:(void(^)(UITextView *textView))didChangeSelectionBlock{
    [self.delegateProxy addSelector:@selector(textViewDidChange:) callback:^(NSArray *params) {
        if (didChangeSelectionBlock && params.count == 1) {
            didChangeSelectionBlock(params[0]);
        }
    }];
}

- (void)shouldBeginEditing:(BOOL(^)(UITextView *textView))shouldBeginEditingBlock {
    objc_setAssociatedObject(self, kTextViewShouldBeginEditingKey, shouldBeginEditingBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)shouldEndEditing:(BOOL(^)(UITextView *textView))shouldEndEditingBlock {
    objc_setAssociatedObject(self, kTextViewShouldEndEditingKey, shouldEndEditingBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)shouldChangeTextInRange:(BOOL(^)(UITextView *textView,NSRange range,NSString *text))shouldChangeTextInRangeBlock {
    objc_setAssociatedObject(self, kTextViewShouldChangeTextInRangeKey, shouldChangeTextInRangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)shouldInteractWithURL:(BOOL(^)(UITextView *textView,NSURL* URL,NSRange characterRange,UITextItemInteraction interaction))shouldInteractWithURLBlock NS_AVAILABLE_IOS(10_0) {
    objc_setAssociatedObject(self, kTextViewShouldInteractWithURLKey, shouldInteractWithURLBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)shouldInteractWithTextAttachment:(BOOL(^)(UITextView *textView,NSTextAttachment * textAttachment,NSRange characterRange,UITextItemInteraction interaction))shouldInteractWithTextAttachmentBlock NS_AVAILABLE_IOS(10_0) {
    objc_setAssociatedObject(self, kTextViewShouldInteractWithTextAttachmentKey, shouldInteractWithTextAttachmentBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)shouldInteractWithURLOld:(BOOL(^)(UITextView *textView,NSURL* URL,NSRange characterRange))shouldInteractWithURLBlock NS_DEPRECATED_IOS(7_0, 10_0, "use shouldInteractWithURL instead") {
    objc_setAssociatedObject(self, kTextViewShouldInteractWithURLOldKey, shouldInteractWithURLBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)shouldInteractWithTextAttachmentOld:(BOOL(^)(UITextView *textView,NSTextAttachment * textAttachment,NSRange characterRange))shouldInteractWithTextAttachmentBlock NS_DEPRECATED_IOS(7_0, 10_0, "Use shouldInteractWithTextAttachment instead") {
    objc_setAssociatedObject(self, kTextViewShouldInteractWithTextAttachmentOldKey, shouldInteractWithTextAttachmentBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    BOOL (^shouldBeginEditingBlock)(UITextView *alertView) = objc_getAssociatedObject(self, kTextViewShouldBeginEditingKey);
    if (shouldBeginEditingBlock) {
        return shouldBeginEditingBlock(textView);
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    BOOL (^shouldEndEditingBlock)(UITextView *alertView) = objc_getAssociatedObject(self, kTextViewShouldEndEditingKey);
    if (shouldEndEditingBlock) {
        return shouldEndEditingBlock(textView);
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL (^shouldChangeTextInRangeBlock)(UITextView *alertView,NSRange range,NSString *text) = objc_getAssociatedObject(self, kTextViewShouldChangeTextInRangeKey);
    if (shouldChangeTextInRangeBlock) {
        return shouldChangeTextInRangeBlock(textView,range,text);
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0){
    BOOL (^shouldInteractWithURLBlock)(UITextView *alertView,NSURL* URL,NSRange characterRange,UITextItemInteraction interaction) = objc_getAssociatedObject(self, kTextViewShouldInteractWithURLKey);
    if (shouldInteractWithURLBlock) {
        return shouldInteractWithURLBlock(textView,URL,characterRange,interaction);
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0){
    BOOL (^shouldInteractWithTextAttachmentBlock)(UITextView *alertView,NSTextAttachment * textAttachment,NSRange characterRange,UITextItemInteraction interaction) = objc_getAssociatedObject(self, kTextViewShouldInteractWithTextAttachmentKey);
    if (shouldInteractWithTextAttachmentBlock) {
        return shouldInteractWithTextAttachmentBlock(textView,textAttachment,characterRange,interaction);
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_DEPRECATED_IOS(7_0, 10_0, "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead"){
    BOOL (^shouldInteractWithURLBlock)(UITextView *alertView,NSURL* URL,NSRange characterRange) = objc_getAssociatedObject(self, kTextViewShouldInteractWithURLOldKey);
    if (shouldInteractWithURLBlock) {
        return shouldInteractWithURLBlock(textView,URL,characterRange);
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_DEPRECATED_IOS(7_0, 10_0, "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead"){
    BOOL (^shouldInteractWithTextAttachmentBlock)(UITextView *alertView,NSTextAttachment * textAttachment,NSRange characterRange) = objc_getAssociatedObject(self, kTextViewShouldInteractWithTextAttachmentOldKey);
    if (shouldInteractWithTextAttachmentBlock) {
        return shouldInteractWithTextAttachmentBlock(textView,textAttachment,characterRange);
    }
    return YES;
}

- (void)keyboardInputChangedSelection:(UITextView *)textView {
    NSLog(@"keyboardInputChangedSelection%@",textView.text);
}

- (void)keyboardInputChanged:(UITextView *)textView {
    NSLog(@"keyboardInputChanged%@",textView.text);
}
- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(UITextViewDelegate)];
        delegateProxy.delegate = self;
        self.delegate = (id<UITextViewDelegate>)delegateProxy;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}

- (void)dealloc {
    NSLog(@"text view dealloc");
}
@end
