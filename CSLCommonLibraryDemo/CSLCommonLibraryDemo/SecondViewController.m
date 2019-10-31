//
//  SecondViewController.m
//  CSLCommonLibraryDemo
//
//  Created by SZDT00135 on 2019/10/24.
//  Copyright © 2019 csl. All rights reserved.
//

#import "SecondViewController.h"
#import "UIControl+Events.h"
#import "UIGestureRecognizer+Action.h"
#import "UIImagePickerController+DelegateProxy.h"
#import "UITextView+DelegateProxy.h"

@interface SecondViewController ()
@property (nonatomic, strong)UITextView *textView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof (self) weakSelf = self;
    UIControl *control = [[UIControl alloc]init];
    [control onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * control) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        /**
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker onEventChange:strongSelf event:UIControlEventValueChanged change:^(UIControl * control) {
            if ([control isKindOfClass:[UIDatePicker class]]) {
                UIDatePicker *datePicker = (UIDatePicker *)control;
                NSLog(@"datePicker%@", datePicker.date);
            }
        }];
        datePicker.backgroundColor = [UIColor greenColor];
        datePicker.frame = CGRectMake(0, strongSelf.view.frame.size.height-200, strongSelf.view.frame.size.width, 200);
        [strongSelf.view addSubview:datePicker];
         */
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = NO;
        [picker imagePickerCancel:^(UIImagePickerController* controller) {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        [picker imagePickerFinish:^(UIImagePickerController* controller, NSDictionary<UIImagePickerControllerInfoKey, id>* info) {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        [strongSelf presentViewController:picker animated:YES completion:nil];
    }];
    control.backgroundColor = [UIColor redColor];
    control.frame = CGRectMake(100, 100, 200, 20);
    [self.view addSubview:control];
    UIView *viewC = [[UIView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 50)];
    viewC.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:viewC];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]init];
    [gesture on:self click:^(UIGestureRecognizer * gesture) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSLog(@"gesture%@", gesture);
        [strongSelf.textView resignFirstResponder];
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [viewC addGestureRecognizer:gesture];
    
    UITextView *textView = [UITextView new];
    textView.frame = CGRectMake(0, 350, self.view.frame.size.width, 80);
    textView.editable = YES;
    textView.backgroundColor = [UIColor greenColor];
    textView.textColor = [UIColor redColor];
    textView.font = [UIFont systemFontOfSize:30];
    textView.scrollEnabled = YES;
    [textView didBeginEditing:^(UITextView * _Nonnull textView) {
        NSLog(@"开始编辑");
    }];
    [textView didEndEditing:^(UITextView * _Nonnull textView) {
        NSLog(@"结束编辑");
    }];
    [textView didChange:^(UITextView * _Nonnull textView) {
        NSLog(@"编辑中的文字%@",textView.text);
    }];
    [textView didChangeSelection:^(UITextView * _Nonnull textView) {
        NSLog(@"编辑中的文字变化%@",textView.text);
    }];
    [self.view addSubview:textView];
    self.textView = textView;
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

@end
