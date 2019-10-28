//
//  SecondViewController.m
//  CSLCommonLibraryDemo
//
//  Created by SZDT00135 on 2019/10/24.
//  Copyright © 2019 csl. All rights reserved.
//

#import "SecondViewController.h"

#import "CSLBaseControl.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    CSLBaseControl *control = [[CSLBaseControl alloc]initWithTarget:self controlEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull control){
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    control.backgroundColor = [UIColor redColor];
    control.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:control];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(doSomething::)]) {
        [self.delegate doSomething:true :@"hello"];
    }
}

- (void)dealloc {
    NSLog(@"second vc dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
