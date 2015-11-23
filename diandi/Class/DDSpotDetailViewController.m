//
//  DDSpotDetailViewController.m
//  diandi
//
//  Created by kjubo on 15/11/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotDetailViewController.h"
#import "DDDetailHeaderView.h"
#import "DDShareHeaderView.h"
#import "DDSpotShareTableViewCell.h"
#import "DDCustomShareInfoModel.h"

@interface DDSpotDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) DDDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tbList;
@property (nonatomic, strong) DDShareHeaderView *shareHeaderView;
@property (nonatomic, strong) NSMutableArray *shareList;
@end

static NSString *kCellReuseIdentifier = @"kCellReuseIdentifier";
@implementation DDSpotDetailViewController

- (void)viewDidLoad{
    self.headerView = [DDDetailHeaderView new];
    [self.headerView setSpotModel:self.spotModel];
    self.headerView.height = (DF_WIDTH * (180.0/375.0)) + 460.0;
    
    self.shareHeaderView = [DDShareHeaderView new];
    
    self.tbList = [UITableView new];
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbList.tableHeaderView = self.headerView;
    self.tbList.estimatedRowHeight = 88;
    [self.tbList registerClass:[DDSpotShareTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    [self.view addSubview:self.tbList];
    [self.tbList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.shareHeaderView setShareCount:2234];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)btnClick_keepSpot{
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.shareList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSpotShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCustomShareInfoModel *item = self.shareList[indexPath.row];
    return [DDSpotShareTableViewCell heightForDetail:item.shareInfo.content];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.shareHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120;
}

@end
