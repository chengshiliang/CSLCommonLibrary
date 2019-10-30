//
//  UICollectionReusableView+RACSignalSupport.m
//  ReactiveObjC
//
//  Created by Kent Wong on 2013-10-04.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "UITableViewHeaderFooterView+DelegateProxy.h"
#import "NSObject+Base.h"

@implementation UITableViewHeaderFooterView (DelegateProxy)

- (void)reusableCallback:(void(^)(id))callback {
    [self addSelector:@selector(prepareForReuse) fromProtocol:nil callback:callback];
}

- (void)dealloc{
    NSLog(@"UITableViewHeaderFooterView dealloc");
}
@end
