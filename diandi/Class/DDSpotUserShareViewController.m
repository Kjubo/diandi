//
//  DDSpotUserShareViewController.m
//  diandi
//
//  Created by kjubo on 15/12/4.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotUserShareViewController.h"
#import "DDSpotTableViewCell.h"
@interface DDSpotUserShareViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *lbSpotName;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIButton *btnShareType;
@property (nonatomic, strong) UITextView *tvShareContent;
@property (nonatomic, strong) UITableView *tbShareInfo;
@end

static NSString *kCellReuseIdentifier = @"kCellReuseIdentifier";
@implementation DDSpotUserShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_eye"]];
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 14));
        make.centerY.mas_equalTo(@40);
        make.left.equalTo(self.view).offset(15);
    }];
    
    self.lbSpotName = [UILabel new];
    self.lbSpotName.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lbSpotName.backgroundColor = [UIColor clearColor];
    self.lbSpotName.textColor = GS_COLOR_BLACK;
    self.lbSpotName.font = [UIFont gs_font:NSAppFontM];
    [self.view addSubview:self.lbSpotName];
    [self.lbSpotName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-15);
        make.centerY.equalTo(icon);
    }];
    
    self.headerView = [self newHeaderView];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbSpotName.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@44);
    }];
    
    self.editView = [self newEditView];
    self.editView.hidden = YES;
    [self.view addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@100);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    self.tbShareInfo = [UITableView new];
    self.tbShareInfo.backgroundColor = GS_COLOR_WHITE;
    self.tbShareInfo.delegate = self;
    self.tbShareInfo.dataSource = self;
    self.tbShareInfo.separatorColor = [UIColor clearColor];
    self.tbShareInfo.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbShareInfo registerClass:[DDSpotTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    [self.view addSubview:self.tbShareInfo];
    [self.tbShareInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).priority(250);
        make.top.equalTo(self.editView.mas_bottom).priority(500);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSpotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UIButton Click
- (void)btnClick_beginEdit{
    
}

- (void)btnClick_endEdit{
    
}

- (void)btnClick_submit{
    
}

- (void)btnClick_changeShareType{
    
}

#pragma mark - view init
- (UIView *)newEditView{
    UIView *view = [UIView new];
    view.backgroundColor = GS_COLOR_WHITE;
    
    UIView *line = [UIView new];
    line.backgroundColor = GS_COLOR_LIGHT;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(view);
        make.height.mas_equalTo(@1);
    }];
    
    self.btnShareType = [UIButton new];
    [self.btnShareType addTarget:self action:@selector(btnClick_changeShareType) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.btnShareType];
    [self.btnShareType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.left.equalTo(view).offset(10);
    }];
    
    self.tvShareContent = [UITextView new];
    self.tvShareContent.backgroundColor = [UIColor clearColor];
    self.tvShareContent.font = [UIFont gs_font:NSAppFontM];
    [view addSubview:self.tvShareContent];
    [self.tvShareContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnShareType);
        make.left.equalTo(self.btnShareType.mas_right).offset(10);
        make.bottom.equalTo(view).offset(-10);
    }];
    
    return view;
}

- (UIView *)newHeaderView{
    CGSize buttonSize = CGSizeMake(50, 20);
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = GS_COLOR_WHITE;
    
    UIView *line = [UIView new];
    line.backgroundColor = GS_COLOR_LIGHT;
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(headerView);
        make.height.mas_equalTo(@1);
    }];
    
    line = [UIView new];
    line.backgroundColor = GS_COLOR_LIGHT;
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(headerView);
        make.height.mas_equalTo(@1);
    }];
    
    self.btnAdd = [self newHeaderButton:@"+"];
    [self.btnAdd addTarget:self action:@selector(btnClick_beginEdit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.btnAdd];
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.centerY.equalTo(headerView);
        make.right.equalTo(headerView).offset(-20);
    }];
    
    self.btnCancel = [self newHeaderButton:@"取消"];
    self.btnCancel.hidden = YES;
    [self.btnCancel addTarget:self action:@selector(btnClick_endEdit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.btnCancel];
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.centerY.equalTo(headerView);
        make.right.equalTo(headerView).offset(-20);
    }];
    
    self.btnSubmit = [self newHeaderButton:@"确定"];
    self.btnSubmit.hidden = YES;
    [self.btnSubmit addTarget:self action:@selector(btnClick_submit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.btnCancel];
    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.centerY.equalTo(headerView);
        make.right.equalTo(headerView).offset(-100);
    }];
    return headerView;
}

- (UIButton *)newHeaderButton:(NSString *)title{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont gs_font:NSAppFontM];
    [btn setTitleColor:GS_COLOR_BLUE forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

@end
