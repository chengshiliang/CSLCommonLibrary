//
//  UICollectionReusableView+RACSignalSupport.m
//  ReactiveObjC
//
//  Created by Kent Wong on 2013-10-04.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "UICollectionReusableView+DelegateProxy.h"
#import "NSObject+Base.h"

@implementation UICollectionReusableView (RACSignalSupport)

- (void)reusableCallback:(void(^)(id))callback {
    [self addSelector:@selector(prepareForReuse) fromProtocol:nil callback:callback];
}

@end
