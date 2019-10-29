//
//  UIActionSheet+DeleteProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import "UIActionSheet+DelegateProxy.h"
#import <objc/runtime.h>
#import "CSLDelegateProxy.h"

@implementation UIActionSheet (DelegateProxy)
- (void)buttonClicked:(void(^)(UIActionSheet *actionSheet, int clickIndex))clickBlock{
    [self.delegateProxy addSelector:@selector(actionSheet:clickedButtonAtIndex:) callback:^(NSArray *params) {
        if (clickBlock && params.count == 2) {
            clickBlock(params[0],[params[1]intValue]);
        }
    }];
}
- (void)cancel:(void(^)(UIActionSheet *actionSheet))cancelBlock{
    [self.delegateProxy addSelector:@selector(actionSheetCancel:) callback:^(NSArray *params) {
        if (cancelBlock && params.count == 1) {
            cancelBlock(params[0]);
        }
    }];
}
- (void)willPresent:(void(^)(UIActionSheet *actionSheet))willPresentBlock{
    [self.delegateProxy addSelector:@selector(willPresentActionSheet:) callback:^(NSArray *params) {
        if (willPresentBlock && params.count == 1) {
            willPresentBlock(params[0]);
        }
    }];
}
- (void)didPresent:(void(^)(UIActionSheet *actionSheet))didPresentBlock{
    [self.delegateProxy addSelector:@selector(didPresentActionSheet:) callback:^(NSArray *params) {
        if (didPresentBlock && params.count == 1) {
            didPresentBlock(params[0]);
        }
    }];
}
- (void)willDismiss:(void(^)(UIActionSheet *actionSheet, int clickIndex))willDismissBlock{
    [self.delegateProxy addSelector:@selector(actionSheet:willDismissWithButtonIndex:) callback:^(NSArray *params) {
        if (willDismissBlock && params.count == 2) {
            willDismissBlock(params[0],[params[1]intValue]);
        }
    }];
}
- (void)didDismiss:(void(^)(UIActionSheet *actionSheet, int clickIndex))didDismissBlock{
    [self.delegateProxy addSelector:@selector(actionSheet:didDismissWithButtonIndex:) callback:^(NSArray *params) {
        if (didDismissBlock && params.count == 2) {
            didDismissBlock(params[0],[params[1]intValue]);
        }
    }];
}

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(UIActionSheetDelegate)];
        self.delegate = (id<UIActionSheetDelegate>)delegateProxy;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}

- (void)dealloc {
    NSLog(@"action sheet dealloc");
}
@end
