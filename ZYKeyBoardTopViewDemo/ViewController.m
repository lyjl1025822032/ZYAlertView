//
//  ViewController.m
//  ZYKeyBoardTopViewDemo
//
//  Created by yao on 2018/3/2.
//  Copyright © 2018年 王智垚. All rights reserved.
//

#import "ViewController.h"
#import "CMAllMediaInputView.h"
#import "CMAMCustonAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)handleServerNumber:(UIButton *)sender {
    CMAllMediaInputView *inputView = [[CMAllMediaInputView alloc] init];
    inputView.resultTextBlock = ^(NSString *text) {
        NSLog(@"服务密码:%@", text);
    };
    [inputView showInputView:CMAMInputViewTypeServerNumber];
}

- (IBAction)handleIDCardNumber:(UIButton *)sender {
    CMAllMediaInputView *inputView = [[CMAllMediaInputView alloc] init];
    inputView.resultTextBlock = ^(NSString *text) {
        NSLog(@"身份证:%@", text);
    };
    [inputView showInputView:CMAMInputViewTypeIDCardNumber];
}

- (IBAction)handleAuthNumber:(UIButton *)sender {
    CMAllMediaInputView *inputView = [[CMAllMediaInputView alloc] init];
    __weak typeof(inputView)myInputView = inputView;
    inputView.resultTextBlock = ^(NSString *text) {
        NSLog(@"验证码:%@", text);
        if (![text isEqualToString:@"123456"]) {
            [myInputView changeTitleString:@"密码不匹配啊~"];
        }
    };
    [inputView showInputView:CMAMInputViewTypeAuthNumber];
}

- (IBAction)handleLoginButton:(UIButton *)sender {
    CMAMCustonAlertView *alertView = [CMAMCustonAlertView new];
    alertView.confirmBlock = ^{
        NSLog(@"111111");
    };
    [alertView showAlertViewWithTitleStr:@"办理前请先登录哦" andButtonTitle:@"前往登录" andImageIcon:[UIImage imageNamed:@"normalcustom"]];
//    [alertView showAlertViewWithTitleStr:@"啊哦~密码被锁定了!" andButtonTitle:@"知道了" andImageIcon:[UIImage imageNamed:@"failedcustom"]];
}

- (IBAction)handleRemindButton:(UIButton *)sender {
    CMAMCustonAlertView *alertView = [CMAMCustonAlertView new];
    alertView.confirmBlock = ^{
        NSLog(@"confirm");
    };
    [alertView showAlertViewWithTitleStr:@"确认要办理\n4G飞享套餐-28元A套餐吗?"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
