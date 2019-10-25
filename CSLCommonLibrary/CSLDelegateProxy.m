//
//  CSLDelegateProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/24.
//

#import "CSLDelegateProxy.h"
#import <objc/runtime.h>

@interface CSLDelegateProxy()
@property (nonatomic, weak) id protocol;
@end

@implementation CSLDelegateProxy
- (instancetype)initWithDelegateProxy:(id)protocol {
    NSCParameterAssert(protocol != NULL);
        
    self.protocol = protocol;
    
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.protocol];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    if ([self.protocol isKindOfClass:[NSObject class]]) {
        return [(NSObject *)self.protocol methodSignatureForSelector:selector];
    }
    
    return [super methodSignatureForSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)selector {
    __autoreleasing id protocol = self.protocol;
    if ([protocol respondsToSelector:selector]) return YES;
    
    return [super respondsToSelector:selector];
}
@end
