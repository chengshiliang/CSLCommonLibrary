//
//  UIAlertView+DelegateProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (DelegateProxy)
- (void)beginEditing:(void(^)(UITextView *textView))beginEditingBlock;
- (void)endEditing:(void(^)(UITextView *textView))endEditingBlock;
- (void)didChange:(void(^)(UITextView *textView))didChangeBlock;
- (void)didChangeSelection:(void(^)(UITextView *textView))didChangeSelectionBlock;

@end

NS_ASSUME_NONNULL_END
