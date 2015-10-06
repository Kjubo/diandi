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
#import "DDSpotTableViewCell.h"

#import "DDSpotModel.h"

@interface DDSpotViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic, strong) DDPopAreaView *popAreaView;
@property (nonatomic, strong) DDMenuButton *btnArea;        //区域
@property (nonatomic, strong) DDMenuButton *btnType;        //分类
@property (nonatomic, strong) DDMenuButton *btnSort;        //排序
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tbList;
@end

static NSString *kCellReuseIdentifier = @"kCellReuseIdentifier";
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
    
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    self.tbList = [UITableView new];
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbList registerClass:[DDSpotTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    [self.containerView addSubview:self.tbList];
    [self.tbList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    self.popAreaView = [DDPopAreaView new];
    [self.containerView addSubview:self.popAreaView];
    [self.popAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
}

- (void)btnClick_menu:(DDMenuButton *)sender{
    if(sender == self.btnArea){
        self.popAreaView.hidden = NO;
    }
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 9.0/15.0 * DF_WIDTH + 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSpotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    DDSpotModel *testModel = [DDSpotModel new];
    testModel.userFaceUri = @"http://fd.topitme.com/d/8b/d4/1187454768482d48bdl.jpg";
    testModel.converImageUri = @"http://www.xutour.com/picture/editor/2007617112212287.jpg";
    testModel.keepCount = 1243;
    testModel.userName = @"Elina";
    testModel.dateSpan = @"2015.02.20-2015.02.23";
    testModel.personCount = @"2人";
    testModel.cost = @"￥10000.00";
    testModel.title = @"日本大阪京都休闲3日游,日本大阪京都休闲3日游日本大阪,京都休闲3日游日本大阪京都休闲3日游";
    [cell setDateModel:testModel];
    return cell;
}



@end
