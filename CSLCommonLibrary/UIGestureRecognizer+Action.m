//
//  UIGestureRecognizer+Action.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/29.
//

#import "UIGestureRecognizer+Action.h"
#import "NSObject+Base.h"
#import <objc/runtime.h>
#import "CSLDelegateProxy.h"

static void *kGesture_Key = "kGesture_Key";

static void *kGestureRecognizerShouldBeginKey = "kGestureRecognizerShouldBeginKey";
static void *kShouldRequireFailureOfGestureRecognizerBlockKey = "kShouldRequireFailureOfGestureRecognizerBlockKey";
static void *kGestureRecognizerShouldReceiveTouchKey = "kGestureRecognizerShouldReceiveTouchKey";

@implementation UIGestureRecognizer (Action)
- (void)on:(NSObject *)target click:(void(^)(UIGestureRecognizer *gesture))clickBlock{
    [self addTarget:self action:@selector(onClick:)];
    [self setClickBlock:clickBlock];
    __weak __typeof(self)weakSelf = self;
    [self swizzMethod:target action:Dealloc callback:^(NSObject *__unsafe_unretained  _Nonnull obj) {
        __strong __typeof(self)strongSelf = weakSelf;
        [strongSelf removeTarget:strongSelf action:@selector(onClick:)];
    }];
}

- (void)setClickBlock:(void (^)(UIGestureRecognizer *gesture))clickBlock {
    objc_setAssociatedObject(self, kGesture_Key, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIGestureRecognizer *gesture))clickBlock {
    return objc_getAssociatedObject(self, kGesture_Key);
}

- (void)onClick:(UIGestureRecognizer *)gesture {
    if (self.clickBlock) {
        self.clickBlock(gesture);
    }
}

- (void)gestureRecognizerShouldBeginBlock:(BOOL(^)(UIGestureRecognizer *gesture))gestureRecognizerShouldBegin {
    [self delegateProxy];
    objc_setAssociatedObject(self, kGestureRecognizerShouldBeginKey, gestureRecognizerShouldBegin, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)shouldRequireFailureOfGestureRecognizerBlock:(BOOL(^)(UIGestureRecognizer *gestureRecognizer,UIGestureRecognizer *otherGestureRecognizer))shouldRequireFailureOfGestureRecognizer {
    [self delegateProxy];
    objc_setAssociatedObject(self, kShouldRequireFailureOfGestureRecognizerBlockKey, shouldRequireFailureOfGestureRecognizer, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)gestureRecognizerShouldReceiveTouchBlock:(BOOL(^)(UIGestureRecognizer *gestureRecognizer,UITouch *touch))gestureRecognizerShouldReceiveTouch {
    [self delegateProxy];
    objc_setAssociatedObject(self, kGestureRecognizerShouldReceiveTouchKey, gestureRecognizerShouldReceiveTouch, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL(^gestureRecognizerShouldBeginBlock)(UIGestureRecognizer *gesture) = objc_getAssociatedObject(self, kGestureRecognizerShouldBeginKey);
    if (gestureRecognizerShouldBeginBlock) {
        return gestureRecognizerShouldBeginBlock(gestureRecognizer);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL(^shouldRequireFailureOfGestureRecognizerBlock)(UIGestureRecognizer *gestureRecognizer,UIGestureRecognizer *otherGestureRecognizer) = objc_getAssociatedObject(self, kShouldRequireFailureOfGestureRecognizerBlockKey);
    if (shouldRequireFailureOfGestureRecognizerBlock) {
        return shouldRequireFailureOfGestureRecognizerBlock(gestureRecognizer, otherGestureRecognizer);
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL(^gestureRecognizerShouldReceiveTouchBlock)(UIGestureRecognizer *gestureRecognizer,UITouch *touch) = objc_getAssociatedObject(self, kGestureRecognizerShouldReceiveTouchKey);
    if (gestureRecognizerShouldReceiveTouchBlock) {
        return gestureRecognizerShouldReceiveTouchBlock(gestureRecognizer, touch);
    }
    return YES;
}

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(UIGestureRecognizerDelegate)];
        delegateProxy.delegate = self;
        self.delegate = (id<UIGestureRecognizerDelegate>)delegateProxy;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}

- (void)dealloc {
//    NSLog(@"gesture dealloc");
}
@end
