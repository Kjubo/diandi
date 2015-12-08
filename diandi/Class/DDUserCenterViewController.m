//
//  DDUserCenterViewController.m
//  diandi
//
//  Created by kjubo on 15/12/4.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDUserCenterViewController.h"

@interface DDUserCenterViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *ivFaceView;
@property (nonatomic, strong) UILabel *lbUserName;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *highlightLine;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UITableView *tbShareInfo;
@property (nonatomic, strong) UITableView *tbFavor;
@property (nonatomic, strong) UITableView *tbHistory;
@property (nonatomic) NSInteger typeIndex;
@end

#define kButtonTitles   @[@"我的分享", @"我的收藏", @"历史浏览"]
#define kButtonWidth    (DF_WIDTH/3.0)
@implementation DDUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _typeIndex = - 1;
    
    UIImageView *ivTopBackGround = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_usercenter_top"]];
    ivTopBackGround.userInteractionEnabled = NO;
    [self.view addSubview:ivTopBackGround];
    [ivTopBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self.view);
        make.height.equalTo(ivTopBackGround.mas_width).dividedBy(375.0/220.0);
    }];
    
    UIButton *btnSetting = [UIButton new];
    [btnSetting setImage:[UIImage imageNamed:@"ic_setting"] forState:UIControlStateNormal];
    btnSetting.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [btnSetting addTarget:self action:@selector(btnClick_setting) forControlEvents:UIControlEventTouchUpInside];
    [ivTopBackGround addSubview:btnSetting];
    [btnSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.equalTo(ivTopBackGround).offset(16);
        make.right.equalTo(ivTopBackGround).offset(-4);
    }];
    
    self.ivFaceView = [UIImageView new];
    self.ivFaceView.backgroundColor = GS_COLOR_LIGHTGRAY;
    self.ivFaceView.clipsToBounds = YES;
    self.ivFaceView.layer.cornerRadius = 40.0;
    self.ivFaceView.layer.borderColor = GS_COLOR_WHITE.CGColor;
    self.ivFaceView.layer.borderWidth = 1.0;
    [ivTopBackGround addSubview:self.ivFaceView];
    [self.ivFaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.top.equalTo(btnSetting.mas_bottom).offset(10);
        make.centerX.equalTo(ivTopBackGround);
    }];
    
    self.lbUserName = [UILabel new];
    self.lbUserName.backgroundColor = [UIColor clearColor];
    self.lbUserName.textColor = GS_COLOR_WHITE;
    self.lbUserName.font = [UIFont gs_font:NSAppFontM];
    [ivTopBackGround addSubview:self.lbUserName];
    [self.lbUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ivFaceView.mas_bottom).offset(6);
        make.centerX.equalTo(ivTopBackGround);
    }];
    
    UIView *buttonBottomLine = [UIView new];
    buttonBottomLine.backgroundColor = GS_COLOR_LIGHTGRAY;
    [self.view addSubview:buttonBottomLine];
    [buttonBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(ivTopBackGround.mas_bottom).offset(45);
        make.height.mas_equalTo(@1);
    }];
    
    self.buttons = [NSMutableArray array];
    for(int i = 0; i < [kButtonTitles count]; i++){
        UIButton *btn = [UIButton new];
        btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont gs_font:NSAppFontM];
        [btn setTitleColor:GS_COLOR_BLACK forState:UIControlStateNormal];
        [btn setTitle:kButtonTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick_changeType:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kButtonWidth, 44));
            make.bottom.equalTo(buttonBottomLine.mas_top);
            make.left.equalTo(self.view).offset(kButtonWidth * i);
        }];
        [self.buttons addObject:btn];
        
        if(i < [kButtonTitles count] - 1){
            UIView *line = [UIView new];
            line.backgroundColor = GS_COLOR_LIGHTGRAY;
            [self.view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(btn.mas_right);
                make.height.equalTo(btn).offset(-10);
                make.centerY.equalTo(btn);
                make.width.mas_equalTo(@1);
            }];
        }
    }
    
    self.highlightLine = [UIView new];
    self.highlightLine.backgroundColor = GS_COLOR_MAIN;
    [self.view addSubview:self.highlightLine];
    [self.highlightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kButtonWidth, 3.0));
        make.bottom.equalTo(buttonBottomLine.mas_bottom);
    }];
    
    self.contentView = [UIScrollView new];
    self.contentView.backgroundColor = GS_COLOR_WHITE;
    self.contentView.delegate = self;
    self.contentView.pagingEnabled = YES;
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.highlightLine.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.tbShareInfo = [UITableView new];
//    self.tbShareInfo.delegate = self;
//    self.tbShareInfo.dataSource = self;
    self.tbShareInfo.separatorColor = [UIColor clearColor];
    self.tbShareInfo.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tbShareInfo];
    [self.tbShareInfo  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
    }];
    
    self.tbFavor = [UITableView new];
//    self.tbFavor.delegate = self;
//    self.tbFavor.dataSource = self;
    self.tbFavor.separatorColor = [UIColor clearColor];
    self.tbFavor.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tbFavor];
    [self.tbFavor  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(DF_WIDTH);
    }];
    
    self.tbHistory = [UITableView new];
//    self.tbHistory.delegate = self;
//    self.tbHistory.dataSource = self;
    self.tbHistory.separatorColor = [UIColor clearColor];
    self.tbHistory.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tbHistory];
    [self.tbHistory  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(DF_WIDTH * 2);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.contentView.contentSize = CGSizeMake(DF_WIDTH * 3, self.contentView.height);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setTypeIndex:(NSInteger)typeIndex{
    if(_typeIndex == typeIndex) return;
    
    if(_typeIndex >= 0 && _typeIndex < [kButtonTitles count]){
        UIButton *btnCurrent = self.buttons[_typeIndex];
        [btnCurrent setTitleColor:GS_COLOR_BLACK forState:UIControlStateNormal];
    }
    if(typeIndex >= 0 && typeIndex < [kButtonTitles count]){
        UIButton *btnCurrent = self.buttons[typeIndex];
        [btnCurrent setTitleColor:GS_COLOR_MAIN forState:UIControlStateNormal];
    }
    [self.highlightLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kButtonWidth * typeIndex);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.highlightLine setNeedsLayout];
        [self.highlightLine layoutIfNeeded];
    }];
    
    _typeIndex = typeIndex;
}

#pragma mark - UITableViewDelegate & Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tbShareInfo){
        return 10;
    }else if(tableView == self.tbFavor){
        return 10;
    }else if(tableView == self.tbHistory){
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - UIButton Click
- (void)btnClick_setting{
    
}

- (void)btnClick_changeType:(UIButton *)sender{
    self.typeIndex = sender.tag;
}


@end
