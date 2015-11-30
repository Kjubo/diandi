//
//  RootViewController.m
//  MyShoping
//
//  Created by boyu on 14-3-1.
//  Copyright (c) 2014年 boyu. All rights reserved.
//

#import "RootViewController.h"
#import "ASWaitingView.h"
#import "MobClick.h"

@interface RootViewController ()
@property (nonatomic, strong) ASWaitingView *waitingView;
@end

@implementation RootViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = GS_COLOR_BACKGROUND;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
#ifndef TEST_SERVER
    [MobClick beginLogPageView:NSStringFromClass([self class])];
#endif
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
#ifndef TEST_SERVER
    [MobClick endLogPageView:NSStringFromClass([self class])];
#endif
}

- (ASWaitingView *)waitingView{
    if(!_waitingView){
        _waitingView = [[ASWaitingView alloc] initWithBaseViewController:self];
    }
    return _waitingView;
}

- (void)loadingShow{
    [self loadingShow:nil];
}

- (void)loadingShow:(NSString *)message{
    [self.waitingView showWating:message];
}

- (void)loadingHidden{
    [self.waitingView hideWaiting];
}

+ (void)showAlert:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

+ (void)callPhone:(NSString *)phoneNumber{
    if([phoneNumber length] == 0){
        [self showAlert:@"电话号码为空"];
        return;
    }
    NSString *uri = [NSString stringWithFormat:@"tel:%@", [phoneNumber trim]];
    BOOL ret = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:uri]];
    if(!ret){
        [self showAlert:@"拨打电话失败"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
