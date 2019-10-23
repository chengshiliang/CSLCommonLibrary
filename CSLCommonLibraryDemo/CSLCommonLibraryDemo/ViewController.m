//
//  ViewController.m
//  CSLCommonLibraryDemo
//
//  Created by SZDT00135 on 2019/10/23.
//  Copyright © 2019 csl. All rights reserved.
//

#import "ViewController.h"

#import "NSNotificationCenter+Base.h"

#import "BaseObserver.h"

#import "TestModel.h"

@interface ViewController ()
{
    int count;
}
@property (nonatomic, strong) TestModel *model;
@property (nonatomic, strong) BaseObserver *observer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [TestModel new];
    self.observer = [[BaseObserver alloc]initWithTarget:self keyPath:@"model.str" options:NSKeyValueObservingOptionNew block:^(id  _Nonnull target, NSDictionary * _Nonnull change) {
        NSLog(@"kvo---%@", change[@"new"]);
    }];
    
    [[NSNotificationCenter defaultCenter]addTarget:self noidtificationName:@"123" object:nil block:^(NSNotification * _Nonnull data) {
        NSLog(@"notify----data%@", data);
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(printNum:) userInfo:nil repeats:true];
}
- (void)printNum:(NSNumber *)number {
    count ++;
    self.model.str = [NSString stringWithFormat:@"xxx%d",count];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"123" object:nil userInfo:@{@"123": @"456"}];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"123" object:nil];
}
- (void)dealloc {
    NSLog(@"firstVC dealloc");
}
@end
