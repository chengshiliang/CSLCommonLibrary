//
//  NSObject+Base.m
//  ReactiveCocoa
//
//  Created by SZDT00135 on 2019/10/22.
//  Copyright © 2019 SZDT00135. All rights reserved.
//

#import "NSObject+Base.h"
#import "NSInvocation+Base.h"

#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSObject (Base)

static NSMutableSet *swizzledClasses() {
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    
    return swizzledClasses;
}

static NSString * const SelectorAliasPrefix = @"csl_alias_";
static NSString * const SubclassSuffix = @"_Selector";
static void *SubclassAssociationKey = &SubclassAssociationKey;
static void *ClassDeallocAssociationKey = &ClassDeallocAssociationKey;
static void *ClassDisappearAssociationKey = &ClassDisappearAssociationKey;

static NSArray* ArgumentsTuple(NSInvocation *invocation) {
    NSUInteger numberOfArguments = invocation.methodSignature.numberOfArguments;
    NSMutableArray *argumentsArray = [NSMutableArray arrayWithCapacity:numberOfArguments - 2];
    for (NSUInteger index = 2; index < numberOfArguments; index++) {
        [argumentsArray addObject:[invocation argumentAtIndex:index] ?: nil];
    }
    
    return argumentsArray.copy;
}

Method getImmediateInstanceMethod (Class aClass, SEL aSelector) {
    unsigned methodCount = 0;
    Method *methods = class_copyMethodList(aClass, &methodCount);
    Method foundMethod = NULL;
    
    for (unsigned methodIndex = 0;methodIndex < methodCount;++methodIndex) {
        if (method_getName(methods[methodIndex]) == aSelector) {
            foundMethod = methods[methodIndex];
            break;
        }
    }
    
    free(methods);
    return foundMethod;
}

static BOOL ForwardInvocation(id self, NSInvocation *invocation) {
    SEL aliasSelector = AliasForSelector(invocation.selector);
    
    Class class = object_getClass(invocation.target);
    BOOL respondsToAlias = [class instancesRespondToSelector:aliasSelector];
    if (respondsToAlias) {
        invocation.selector = aliasSelector;
        [invocation invoke];
    }
    NSArray *result = ArgumentsTuple(invocation);
    void(^callback)(id)  = objc_getAssociatedObject(self, aliasSelector);
    if (!callback) return respondsToAlias;
    callback(result);
    return YES;
}

static void SwizzleForwardInvocation(Class class) {
    SEL forwardInvocationSEL = @selector(forwardInvocation:);
    Method forwardInvocationMethod = class_getInstanceMethod(class, forwardInvocationSEL);
    void (*originalForwardInvocation)(id, SEL, NSInvocation *) = NULL;
    if (forwardInvocationMethod != NULL) {
        originalForwardInvocation = (__typeof__(originalForwardInvocation))method_getImplementation(forwardInvocationMethod);
    }
    id newForwardInvocation = ^(id self, NSInvocation *invocation) {
        BOOL matched = ForwardInvocation(self, invocation);
        if (matched) return;
        
        if (originalForwardInvocation == NULL) {
            [self doesNotRecognizeSelector:invocation.selector];
        } else {
            originalForwardInvocation(self, forwardInvocationSEL, invocation);
        }
    };
    
    class_replaceMethod(class, forwardInvocationSEL, imp_implementationWithBlock(newForwardInvocation), "v@:@");
}

static void SwizzleRespondsToSelector(Class class) {
    SEL respondsToSelectorSEL = @selector(respondsToSelector:);
    
    Method respondsToSelectorMethod = class_getInstanceMethod(class, respondsToSelectorSEL);
    BOOL (*originalRespondsToSelector)(id, SEL, SEL) = (__typeof__(originalRespondsToSelector))method_getImplementation(respondsToSelectorMethod);
    id newRespondsToSelector = ^ BOOL (id self, SEL selector) {
        Method method = getImmediateInstanceMethod(class, selector);
        
        if (method != NULL && method_getImplementation(method) == _objc_msgForward) {
            SEL aliasSelector = AliasForSelector(selector);
            if (objc_getAssociatedObject(self, aliasSelector) != nil) return YES;
        }
        
        return originalRespondsToSelector(self, respondsToSelectorSEL, selector);
    };
    
    class_replaceMethod(class, respondsToSelectorSEL, imp_implementationWithBlock(newRespondsToSelector), method_getTypeEncoding(respondsToSelectorMethod));
}

static void SwizzleGetClass(Class class, Class statedClass) {
    SEL selector = @selector(class);
    Method method = class_getInstanceMethod(class, selector);
    IMP newIMP = imp_implementationWithBlock(^(id self) {
        return statedClass;
    });
    class_replaceMethod(class, selector, newIMP, method_getTypeEncoding(method));
}

static void SwizzleMethodSignatureForSelector(Class class) {
    IMP newIMP = imp_implementationWithBlock(^(id self, SEL selector) {
        Class actualClass = object_getClass(self);
        Method method = class_getInstanceMethod(actualClass, selector);
        if (method == NULL) {
            struct objc_super target = {
                .super_class = class_getSuperclass(class),
                .receiver = self,
            };
            NSMethodSignature * (*messageSend)(struct objc_super *, SEL, SEL) = (__typeof__(messageSend))objc_msgSendSuper;
            return messageSend(&target, @selector(methodSignatureForSelector:), selector);
        }
        
        char const *encoding = method_getTypeEncoding(method);
        return [NSMethodSignature signatureWithObjCTypes:encoding];
    });
    
    SEL selector = @selector(methodSignatureForSelector:);
    Method methodSignatureForSelectorMethod = class_getInstanceMethod(class, selector);
    class_replaceMethod(class, selector, newIMP, method_getTypeEncoding(methodSignatureForSelectorMethod));
}

static Class SwizzleClass(NSObject *target) {
    Class statedClass = target.class;
    Class baseClass = object_getClass(target);
    Class knownDynamicSubclass = objc_getAssociatedObject(target, SubclassAssociationKey);
    if (knownDynamicSubclass != Nil) return knownDynamicSubclass;
    
    NSString *className = NSStringFromClass(baseClass);
    
    if (statedClass != baseClass) {
        @synchronized (swizzledClasses()) {
            if (![swizzledClasses() containsObject:className]) {
                SwizzleForwardInvocation(baseClass);
                SwizzleRespondsToSelector(baseClass);
                SwizzleGetClass(baseClass, statedClass);
                SwizzleGetClass(object_getClass(baseClass), statedClass);
                SwizzleMethodSignatureForSelector(baseClass);
                [swizzledClasses() addObject:className];
            }
        }
        
        return baseClass;
    }
    
    const char *subclassName = [className stringByAppendingString:SubclassSuffix].UTF8String;
    Class subclass = objc_getClass(subclassName);
    
    if (subclass == nil) {
        subclass = objc_allocateClassPair(baseClass, subclassName, 0);
        if (subclass == nil) return nil;
        
        SwizzleForwardInvocation(subclass);
        SwizzleRespondsToSelector(subclass);
        
        SwizzleGetClass(subclass, statedClass);
        SwizzleGetClass(object_getClass(subclass), statedClass);
        
        SwizzleMethodSignatureForSelector(subclass);
        
        objc_registerClassPair(subclass);
    }
    
    object_setClass(target, subclass);
    objc_setAssociatedObject(target, SubclassAssociationKey, subclass, OBJC_ASSOCIATION_ASSIGN);
    return subclass;
}

static SEL AliasForSelector(SEL originalSelector) {
    NSString *selectorName = NSStringFromSelector(originalSelector);
    return NSSelectorFromString([SelectorAliasPrefix stringByAppendingString:selectorName]);
}

static const char *SignatureForUndefinedSelector(SEL selector) {
    const char *name = sel_getName(selector);
    NSMutableString *signature = [NSMutableString stringWithString:@"v@:"];
    
    while ((name = strchr(name, ':')) != NULL) {
        [signature appendString:@"@"];
        name++;
    }
    
    return signature.UTF8String;
}

static void NSObjectForSelector(NSObject *target, SEL selector, Protocol *protocol, void(^callback)(id)) {
    SEL aliasSelector = AliasForSelector(selector);
    
    @synchronized (target) {
        Class class = SwizzleClass(target);
        objc_setAssociatedObject(target, aliasSelector, callback, OBJC_ASSOCIATION_RETAIN);
        Method targetMethod = class_getInstanceMethod(class, selector);
        if (targetMethod == NULL) {
            const char *typeEncoding;
            if (protocol == NULL) {
                typeEncoding = SignatureForUndefinedSelector(selector);
            } else {
                // Look for the selector as an optional instance method.
                struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
                
                if (methodDescription.name == NULL) {
                    // Then fall back to looking for a required instance
                    // method.
                    methodDescription = protocol_getMethodDescription(protocol, selector, YES, YES);
                    NSCAssert(methodDescription.name != NULL, @"Selector %@ does not exist in <%s>", NSStringFromSelector(selector), protocol_getName(protocol));
                }
                
                typeEncoding = methodDescription.types;
            }
            
            class_addMethod(class, selector, _objc_msgForward, typeEncoding);
        } else if (method_getImplementation(targetMethod) != _objc_msgForward) {
            // Make a method alias for the existing method implementation.
            const char *typeEncoding = method_getTypeEncoding(targetMethod);
            
            BOOL addedAlias __attribute__((unused)) = class_addMethod(class, aliasSelector, method_getImplementation(targetMethod), typeEncoding);
            NSCAssert(addedAlias, @"Original implementation for %@ is already copied to %@ on %@", NSStringFromSelector(selector), NSStringFromSelector(aliasSelector), class);
            
            // Redefine the selector to call -forwardInvocation:.
            class_replaceMethod(class, selector, _objc_msgForward, method_getTypeEncoding(targetMethod));
        }
    }
}

- (void)swizzDeallocMethod:(NSObject *)target callback:(void(^)(__unsafe_unretained NSObject *deallocObj))callback {
    @synchronized (swizzledClasses()) {
        NSMutableArray *callbackArrayM = objc_getAssociatedObject(target, ClassDeallocAssociationKey);
        if (!callbackArrayM) {
            callbackArrayM = [NSMutableArray array];
        }
        [callbackArrayM addObject:[callback copy]];
        objc_setAssociatedObject(target, ClassDeallocAssociationKey, callbackArrayM.mutableCopy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        Class classToSwizzle = target.class;
        NSString *className = [NSStringFromClass(classToSwizzle) stringByAppendingString:@"Dealloc"];
        if ([swizzledClasses() containsObject:className]) return;
        SEL deallocSelector = sel_registerName("dealloc");
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        id newDealloc = ^(__unsafe_unretained NSObject *deallocObj) {
            ;
            NSMutableArray *realCallbackArray = objc_getAssociatedObject(deallocObj, ClassDeallocAssociationKey);
            if (realCallbackArray) {
                for (void(^currentCallback)(__unsafe_unretained NSObject *deallocObj) in realCallbackArray) {
                    if (currentCallback) {
                        currentCallback(deallocObj);
                    }
                }
                objc_setAssociatedObject(deallocObj, ClassDeallocAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
        };
        
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
        if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, method_getTypeEncoding(deallocMethod))) {
            originalDealloc = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
            originalDealloc = (__typeof__(originalDealloc))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        [swizzledClasses() addObject:className];
    }
}

- (void)swizzDisappearMethod:(NSObject *)target callback:(void(^)(__unsafe_unretained NSObject *disappearObj))callback {
    @synchronized (swizzledClasses()) {
        NSMutableArray *callbackArrayM = objc_getAssociatedObject(target, ClassDisappearAssociationKey);
        if (!callbackArrayM) {
            callbackArrayM = [NSMutableArray array];
        }
        [callbackArrayM addObject:[callback copy]];
        objc_setAssociatedObject(target, ClassDisappearAssociationKey, callbackArrayM.mutableCopy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        Class classToSwizzle = target.class;
        NSString *className = [NSStringFromClass(classToSwizzle) stringByAppendingString:@"Disappear"];
        if ([swizzledClasses() containsObject:className]) return;
        SEL disappearSelector = sel_registerName("viewWillDisappear:");
        __block void (*originalDisappear)(__unsafe_unretained id, SEL) = NULL;
        id newDisappear = ^(__unsafe_unretained NSObject *disappearObj) {
            NSMutableArray *realCallbackArray = objc_getAssociatedObject(disappearObj, ClassDisappearAssociationKey);
            if (realCallbackArray) {
                for (void(^currentCallback)(__unsafe_unretained NSObject *disappearObj) in realCallbackArray) {
                    if (currentCallback) {
                        currentCallback(disappearObj);
                    }
                }
                objc_setAssociatedObject(disappearObj, ClassDisappearAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            if (originalDisappear == NULL) {
                struct objc_super superInfo = {
                    .receiver = disappearObj,
                    .super_class = class_getSuperclass(classToSwizzle)
                };
                
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, disappearSelector);
            } else {
                originalDisappear(disappearObj, disappearSelector);
            }
        };
        
        IMP newDisappearIMP = imp_implementationWithBlock(newDisappear);
        Method disappearMethod = class_getInstanceMethod(classToSwizzle, disappearSelector);
        if (!class_addMethod(classToSwizzle, disappearSelector, newDisappearIMP, method_getTypeEncoding(disappearMethod))) {
            originalDisappear = (__typeof__(originalDisappear))method_getImplementation(disappearMethod);
            originalDisappear = (__typeof__(originalDisappear))method_setImplementation(disappearMethod, newDisappearIMP);
        }
        [swizzledClasses() addObject:className];
    }
}

- (void)addSelector:(SEL)selector fromProtocol:(_Nullable id)protocol callback:(void(^)(id))callback{
    NSObjectForSelector(self, selector, protocol, callback);
}
@end
