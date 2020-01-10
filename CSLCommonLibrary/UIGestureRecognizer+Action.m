//
//  UIGestureRecognizer+Action.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/29.
//

#import "UIGestureRecognizer+Action.h"
#import "NSObject+Base.h"
#import <objc/runtime.h>

static void *kGesture_Key = "kGesture_Key";

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

- (void)dealloc {
//    NSLog(@"gesture dealloc");
}
@end
