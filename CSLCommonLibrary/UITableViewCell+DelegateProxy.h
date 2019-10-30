//
//  UICollectionReusableView+RACSignalSupport.h
//  ReactiveObjC
//
//  Created by Kent Wong on 2013-10-04.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (DelegateProxy)

- (void)reusableCallback:(void(^)(id))callback;

@end

NS_ASSUME_NONNULL_END
