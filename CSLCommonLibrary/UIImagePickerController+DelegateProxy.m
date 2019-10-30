//
//  UIImagePickerController+DelegateProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/30.
//

#import "UIImagePickerController+DelegateProxy.h"
#import <objc/runtime.h>
#import "CSLDelegateProxy.h"

@implementation UIImagePickerController (DelegateProxy)
- (void)imagePickerCancel:(void (^)(UIImagePickerController* controler))cancelBlock {
    [self.delegateProxy addSelector:@selector(imagePickerControllerDidCancel:) callback:^(NSArray *params) {
        if (cancelBlock && params.count == 1) {
            cancelBlock(params[0]);
        }
    }];
}

- (void)imagePickerFinish:(void (^)(UIImagePickerController* controler, NSDictionary<UIImagePickerControllerInfoKey, id>* info))finishBlock {
    [self.delegateProxy addSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:) callback:^(NSArray *params) {
        if (finishBlock && params.count == 2) {
            finishBlock(params[0],params[1]);
        }
    }];
}

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(UIImagePickerControllerDelegate)];
        self.delegate = (id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegateProxy;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}

- (void)dealloc {
    NSLog(@"image picker dealloc");
}
@end
