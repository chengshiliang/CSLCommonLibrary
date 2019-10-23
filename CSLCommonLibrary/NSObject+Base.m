//
//  NSObject+Base.m
//  ReactiveCocoa
//
//  Created by SZDT00135 on 2019/10/22.
//  Copyright © 2019 SZDT00135. All rights reserved.
//

#import "NSObject+Base.h"
#import <objc/message.h>

@implementation NSObject (Base)

static NSMutableSet *swizzledClasses() {
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    
    return swizzledClasses;
}

- (void)swizzDeallocMethod:(NSObject *)target callback:(void(^)(__unsafe_unretained NSObject *deallocObj))callback {
    @synchronized (swizzledClasses()) {
        Class classToSwizzle = target.class;
        SEL deallocSelector = sel_registerName("dealloc");
        Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
        IMP tempIMP = method_getImplementation(deallocMethod);
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        id newDealloc = ^(__unsafe_unretained NSObject *deallocObj) {
            if (callback) {
                callback(deallocObj);
            }
            if (originalDealloc == NULL) {
                struct objc_super superInfo = {
                    .receiver = deallocObj,
                    .super_class = class_getSuperclass(classToSwizzle)
                };
                
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            } else {
                originalDealloc(deallocObj, deallocSelector);
            }
            method_setImplementation(deallocMethod, tempIMP);
        };
        
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        
        if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, "v@:")) {
            originalDealloc = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
            originalDealloc = (__typeof__(originalDealloc))method_setImplementation(deallocMethod, newDeallocIMP);
        }
    }
}
@end
