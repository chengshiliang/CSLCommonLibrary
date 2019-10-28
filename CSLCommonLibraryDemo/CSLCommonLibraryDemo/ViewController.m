//
//  ViewController.m
//  CSLCommonLibraryDemo
//
//  Created by SZDT00135 on 2019/10/23.
//  Copyright © 2019 csl. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

#import "NSNotificationCenter+Base.h"
#import "BaseObserver.h"
#import "CSLBaseObject.h"
#import "CSLDelegateProxy.h"
#import "UIAlertView+DelegateProxy.h"

#import "TestModel.h"

@interface ViewController ()
{
    int count;
}
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic, strong) TestModel *model;
@property (nonatomic, strong) BaseObserver *observer;
@property (nonatomic, strong) CSLDelegateProxy *delegateProxy;
@end

@implementation ViewController
- (IBAction)back:(id)sender {
    if ([self.webview canGoBack]) {
        [self.webview goBack];
    }
}

- (IBAction)goNext:(id)sender {
    UIAlertView *actionSheet = [[UIAlertView alloc]initWithTitle:@"actionSheet" message:@"message" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [actionSheet buttonClicked:^(UIAlertView *actionSheet,int clickIndex) {
        if (clickIndex == 1) {
            SecondViewController *vc = [[SecondViewController alloc]init];
            vc.delegate = (id<SecondViewControllerDelegate>)self.delegateProxy;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    
    [actionSheet enableFirstOtherButton:^BOOL(UIAlertView * _Nonnull actionView) {
        return true;
    }];
    
    [actionSheet show];
}

- (CSLDelegateProxy *)delegateProxy {
    if (!_delegateProxy) {
        _delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(SecondViewControllerDelegate)];
        [_delegateProxy addSelector:@selector(doSomething::) callback:^(id params) {
            NSLog(@"delegate callback%@",params);
        }];
    }
    return _delegateProxy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [TestModel new];
    self.observer = [[BaseObserver alloc]initWithTarget:self keyPath:@"model.str" options:NSKeyValueObservingOptionNew block:^(id  _Nonnull target, NSDictionary * _Nonnull change) {
        NSLog(@"kvo---%@", change[@"new"]);
    }];
    
    [[NSNotificationCenter defaultCenter]addTarget:self noidtificationName:@"123" object:nil block:^(NSNotification * _Nonnull data) {
        NSLog(@"notify----data%@", data);
    }];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"src/index" ofType:@"html"];
    NSURL * url = [NSURL fileURLWithPath:path];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    
    id(^block)(id obj) = ^id(id obj) {
        NSLog(@"block excute");
        return obj;
    };
    id obj = [CSLBaseObject invokeArguments:@[@"test"] withBlock:block];
    NSLog(@"call func result---%@",obj);
    
    
}

- (void)dealloc {
    NSLog(@"vc dealloc");
}
@end
