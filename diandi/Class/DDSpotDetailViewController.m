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
#import "DDSpotDetailModel.h"
#import "MJRefresh.h"
#import "DDSpotMapViewController.h"
#import "DDSpotDescViewController.h"
@interface DDSpotDetailViewController ()<UITableViewDelegate, UITableViewDataSource, DDDetailHeaderViewDelegate, DDSpotShareTableViewCellDelegate>
@property (nonatomic, strong) DDDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tbList;
@property (nonatomic, strong) DDShareHeaderView *shareHeaderView;
@property (nonatomic, strong) NSMutableArray *shareList;
@property (nonatomic, strong) DDSpotDetailModel *spotModel;
@property (nonatomic) NSInteger pageno;
@end

static NSString *kCellReuseIdentifier = @"kCellReuseIdentifier";
@implementation DDSpotDetailViewController

- (void)viewDidLoad{
    self.headerView = [DDDetailHeaderView new];
    self.headerView.delegate = self;
    self.headerView.height = 540;
    
    self.shareHeaderView = [DDShareHeaderView new];
    self.shareHeaderView.backgroundColor = GS_COLOR_BACKGROUND;
    
    self.tbList = [UITableView new];
    self.tbList.backgroundColor = GS_COLOR_BACKGROUND;
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbList.tableHeaderView = self.headerView;
    self.tbList.estimatedRowHeight = 88;
    [self.tbList registerClass:[DDSpotShareTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    [self.tbList addFooterWithTarget:self action:@selector(loadMoreShareInfo)];
    [self.view addSubview:self.tbList];
    [self.tbList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadingShow];
    [self loadSpotData];
    [self loadMoreShareInfo];
    
    self.shareList = [NSMutableArray array];
}

- (void)loadSpotData{
    [HttpUtil load:@"api/mdddetail.php"
            params:@{@"uuid" : self.uuid}
        completion:^(BOOL succ, NSString *message, id json) {
            [self loadingHidden];
            if(succ){
                NSError *error;
                self.spotModel = [[DDSpotDetailModel alloc] initWithDictionary:json error:&error];
                NSAssert(!error, @"%@", error);
                [self.headerView setModel:self.spotModel];
                [self.shareHeaderView setShareCount:2234];
            }else{
                [RootViewController showAlert:message];
            }
        }];
}

- (void)loadMoreShareInfo{
    [HttpUtil load:@"api/pllist.php"
            params:@{@"uuid" : @"2fc14e31-123e-461c-9a02-0744182dc274", // self.uuid,
                     @"offset" : @(self.pageno)}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                NSError *error;
                NSArray *lst = [DDCustomShareInfoModel arrayOfModelsFromDictionaries:json[@"list"] error:&error];
                NSAssert(!error, @"%@", error);
                if([lst count] > 0){
                    [self.shareList addObjectsFromArray:lst];
                    self.pageno = [self.shareList count];
                    [self.tbList reloadData];
                }
                self.tbList.footerHidden = [json[@"islate"] boolValue];
            }
        }];
}

- (void)btnClick_keepSpot{
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.shareList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDSpotShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    DDCustomShareInfoModel *model = self.shareList[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCustomShareInfoModel *item = self.shareList[indexPath.row];
    return [DDSpotShareTableViewCell heightForDetail:item.content];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.shareHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120;
}

#pragma mark - DDSpotDetailHeaderView Delegate
- (void)ddDetailHeaderViewDidOpenMap{
    DDSpotMapViewController *vc = [[DDSpotMapViewController alloc] init];
    vc.model = self.spotModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ddDetailHeaderViewDidCall{
    [RootViewController callPhone:self.spotModel.tel];
}

- (void)ddDetailHeaderViewDidOpenDesc{
    DDSpotDescViewController *vc = [[DDSpotDescViewController alloc] init];
    vc.desc = self.spotModel.desc;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
