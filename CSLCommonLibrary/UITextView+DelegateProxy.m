//
//  UIAlertView+DelegateProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import "UITextView+DelegateProxy.h"
#import <objc/runtime.h>
#import "CSLDelegateProxy.h"

@implementation UITextView (DelegateProxy)
- (void)beginEditing:(void(^)(UITextView *textView))beginEditingBlock {
    [self.delegateProxy addSelector:@selector(textViewDidBeginEditing:) callback:^(NSArray *params) {
        if (beginEditingBlock && params.count == 1) {
            beginEditingBlock(params[0]);
        }
    }];
}
- (void)endEditing:(void(^)(UITextView *textView))endEditingBlock;{
    [self.delegateProxy addSelector:@selector(textViewDidEndEditing:) callback:^(NSArray *params) {
        if (endEditingBlock && params.count == 1) {
            endEditingBlock(params[0]);
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

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(UITextViewDelegate)];
        self.delegate = (id<UITextViewDelegate>)delegateProxy;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}

- (void)dealloc {
    NSLog(@"text view dealloc");
}
@end
