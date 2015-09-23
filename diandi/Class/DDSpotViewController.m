//
//  DDSpotViewController.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDSpotViewController.h"
#import "DDPopAreaView.h"
#import "DDGradeView.h"
#import "DDMenuButton.h"

@interface DDSpotViewController ()
@property (nonatomic, strong) DDPopAreaView *popAreaView;
@property (nonatomic, strong) DDMenuButton *btnArea;        //区域
@property (nonatomic, strong) DDMenuButton *btnType;        //分类
@property (nonatomic, strong) DDMenuButton *btnSort;        //排序
@end

@implementation DDSpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = GS_COLOR_MAIN;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@64);
    }];
    
    self.btnArea = [DDMenuButton new];
    self.btnArea.title = @"区域";
    [self.btnArea addTarget:self action:@selector(btnClick_menu:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.btnArea];
    [self.btnArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DF_WIDTH/3.0, 44.0));
        make.left.bottom.equalTo(topView);
    }];
    
    self.btnType = [DDMenuButton new];
    self.btnType.title = @"分类";
    [topView addSubview:self.btnType];
    [self.btnType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DF_WIDTH/3.0, 44.0));
        make.bottom.equalTo(topView);
        make.left.equalTo(self.btnArea.mas_right);
    }];
    
    self.btnSort = [DDMenuButton new];
    self.btnSort.title = @"排序";
    [topView addSubview:self.btnSort];
    [self.btnSort mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DF_WIDTH/3.0, 44.0));
        make.bottom.equalTo(topView);
        make.left.equalTo(self.btnType.mas_right);
    }];
    
    
    self.popAreaView = [DDPopAreaView new];
    self.popAreaView.hidden = YES;
    [self.view addSubview:self.popAreaView];
    [self.popAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadingShow];
}

- (void)btnClick_menu:(DDMenuButton *)sender{
    if(sender == self.btnArea){
        self.popAreaView.hidden = NO;
    }
}

@end
