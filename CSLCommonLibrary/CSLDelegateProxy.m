//
//  CSLDelegateProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/24.
//

#import "CSLDelegateProxy.h"

#import <objc/runtime.h>

#import "NSObject+Base.h"

@interface CSLDelegateProxy()
@property (nonatomic, weak) Protocol *protocol;
@end

@implementation CSLDelegateProxy
- (instancetype)initWithDelegateProxy:(Protocol *)protocol {
    NSCParameterAssert(protocol != NULL);
    
    self = [super init];
    
    self.protocol = protocol;
    class_addProtocol(self.class, protocol);
    
    return self;
}

- (BOOL)isProxy {
    return YES;
}

- (void)addSelector:(SEL)selector callback:(void(^)(id))callback {
    [self addSelector:selector fromProtocol:self.protocol callback:callback];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSLog(@"forwardInvocation%@",NSStringFromSelector(invocation.selector));
    [invocation invokeWithTarget:self.delegate];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    struct objc_method_description methodDescription = protocol_getMethodDescription(self.protocol, selector, NO, YES);
    
    if (methodDescription.name == NULL) {
        methodDescription = protocol_getMethodDescription(self.protocol, selector, YES, YES);
        if (methodDescription.name == NULL) return [super methodSignatureForSelector:selector];
    }
    
    return [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
}

- (BOOL)respondsToSelector:(SEL)selector {
    __autoreleasing id delegate = self.delegate;
    if ([delegate respondsToSelector:selector]) return YES;
    
    return [super respondsToSelector:selector];
}

- (void)dealloc {
    NSLog(@"delegate proxy dealloc");
}
@end
