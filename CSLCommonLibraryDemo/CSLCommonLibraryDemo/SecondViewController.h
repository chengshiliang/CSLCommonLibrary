//
//  SecondViewController.h
//  CSLCommonLibraryDemo
//
//  Created by SZDT00135 on 2019/10/24.
//  Copyright © 2019 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SecondViewControllerDelegate <NSObject>

- (void)doSomething:(BOOL)result :(NSString *)str;

@end

@interface SecondViewController : UIViewController
@property (nonatomic, strong)id<SecondViewControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
