//
//  UIControl+Events.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/29.
//

#import "UIControl+Events.h"
#import "NSObject+Base.h"
#import <objc/runtime.h>

static void *kControl_Key = "kControl_Key";

@implementation UIControl (Events)
- (void)onEventChange:(NSObject *)target event:(UIControlEvents)event change:(void(^)(UIControl *))changeBlock{
    [self addTarget:self action:@selector(eventChange:) forControlEvents:event];
    [self setChangeBlock:changeBlock];
    __weak __typeof(self)weakSelf = self;
    [self swizzDeallocMethod:target callback:^(NSObject * _Nonnull __unsafe_unretained deallocObj) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf removeTarget:strongSelf action:@selector(eventChange:) forControlEvents:event];
    }];
}

- (void)setChangeBlock:(void (^)(UIControl *))changeBlock {
    objc_setAssociatedObject(self, kControl_Key, changeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIControl *))changeBlock {
    return objc_getAssociatedObject(self, kControl_Key);
}

- (void)eventChange:(UIControl *)control {
    if (self.changeBlock) {
        self.changeBlock(control);
    }
}

- (void)dealloc {
    NSLog(@"control dealloc");
}
@end
