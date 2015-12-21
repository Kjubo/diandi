//
//  DDLoginViewController.m
//  diandi
//
//  Created by kjubo on 15/12/15.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDLoginViewController.h"

@interface DDLoginViewController ()
@property (nonatomic, strong) UITextField *tfUserName;
@property (nonatomic, strong) UITextField *tfPassword;
@property (nonatomic, strong) UIButton *btnSubmit;
@end

@implementation DDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登录点滴游";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick_cancel)];
    
    self.tfUserName = [self newTextField:@"用户名"];
    self.tfUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"登录用户名" attributes:@{NSFontAttributeName:[UIFont gs_font:NSAppFontM], NSForegroundColorAttributeName : GS_COLOR_LIGHTGRAY}];
    [self.view addSubview:self.tfUserName];
    [self.tfUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.width.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(@44);
        make.centerX.equalTo(self.view);
    }];
    
    UIView *userNameline = [UIView new];
    userNameline.backgroundColor = GS_COLOR_LIGHT;
    [self.view addSubview:userNameline];
    [userNameline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.tfUserName);
        make.height.mas_equalTo(@1);
        make.top.equalTo(self.tfUserName.mas_bottom);
    }];
    RAC(userNameline, backgroundColor) =
        [RACSignal merge:@[[[self.tfUserName rac_signalForControlEvents:UIControlEventEditingDidBegin] mapReplace:GS_COLOR_MAIN],
                        [[self.tfUserName rac_signalForControlEvents:UIControlEventEditingDidEnd] mapReplace:GS_COLOR_LIGHT]]];
    
    self.tfPassword = [self newTextField:@"密码"];
    self.tfPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"登录密码" attributes:@{NSFontAttributeName:[UIFont gs_font:NSAppFontM], NSForegroundColorAttributeName : GS_COLOR_LIGHTGRAY}];
    self.tfPassword.secureTextEntry = YES;
    [self.view addSubview:self.tfPassword];
    [self.tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.tfUserName);
        make.left.equalTo(self.tfUserName);
        make.top.equalTo(self.tfUserName.mas_bottom).offset(20);
    }];
    
    UIView *passwordline = [UIView new];
    passwordline.backgroundColor = GS_COLOR_LIGHT;
    [self.view addSubview:passwordline];
    [passwordline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.tfPassword);
        make.height.mas_equalTo(@1);
        make.top.equalTo(self.tfPassword.mas_bottom);
    }];
    RAC(passwordline, backgroundColor) =
    [RACSignal merge:@[[[self.tfPassword rac_signalForControlEvents:UIControlEventEditingDidBegin] mapReplace:GS_COLOR_MAIN],
                       [[self.tfPassword rac_signalForControlEvents:UIControlEventEditingDidEnd] mapReplace:GS_COLOR_LIGHT]]];
    
    UIButton *btn = [UIButton new];
    btn.backgroundColor = GS_COLOR_MAIN;
    btn.layer.cornerRadius = 6.0;
    [btn setTitleColor:GS_COLOR_WHITE forState:UIControlStateNormal];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick_submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.tfUserName);
        make.left.equalTo(self.tfUserName);
        make.top.equalTo(self.tfPassword.mas_bottom).offset(20);
    }];
}

- (UITextField *)newTextField:(NSString *)prefixTitle{
    UITextField *tf = [UITextField new];
    UILabel *lbPrefix = [UILabel new];
    lbPrefix.size = CGSizeMake(80, 30);
    lbPrefix.backgroundColor = [UIColor clearColor];
    lbPrefix.textColor = GS_COLOR_BLACK;
    lbPrefix.font = [UIFont gs_font:NSAppFontM];
    lbPrefix.text = [prefixTitle copy];
    lbPrefix.textAlignment = NSTextAlignmentCenter;
    tf.font = [UIFont gs_font:NSAppFontM];
    tf.leftView = lbPrefix;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.clearButtonMode = UITextFieldViewModeAlways;
    return tf;
}

- (void)btnClick_cancel{
    if([self.delegate respondsToSelector:@selector(ddLoginViewControllerCancel)]){
        [self.delegate ddLoginViewControllerCancel];
    }
}

- (void)btnClick_submit{
    
}

@end
