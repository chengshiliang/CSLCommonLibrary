//
//  UIImagePickerController+DelegateProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImagePickerController (DelegateProxy)
- (void)imagePickerCancel:(void(^)(UIImagePickerController* controler))cancelBlock;
- (void)imagePickerFinish:(void(^)(UIImagePickerController* controller, NSDictionary<UIImagePickerControllerInfoKey, id>* info))finishBlock;
@end

NS_ASSUME_NONNULL_END
