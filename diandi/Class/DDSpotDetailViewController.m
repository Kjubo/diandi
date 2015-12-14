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
#import "DDSpotUserShareViewController.h"
#import "DDCacheHelper.h"

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

+ (instancetype)newSpotDetailViewController:(DDSpotModel *)spotInfo{
    DDSpotDetailViewController *vc = [DDSpotDetailViewController new];
    vc.title = [spotInfo.title copy];
    vc.spotInfo = spotInfo;
    [[DDCacheHelper shared] addViewHistory:spotInfo];
    return vc;
}

- (void)viewDidLoad{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+评论" style:UIBarButtonItemStylePlain target:self action:@selector(navToAddShare)];
    
    self.headerView = [DDDetailHeaderView new];
    self.headerView.delegate = self;
    self.headerView.height = 540;
    
    self.shareHeaderView = [DDShareHeaderView new];
    self.shareHeaderView.backgroundColor = GS_COLOR_BACKGROUND;
    [self.shareHeaderView setShareCount:0];
    
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

- (void)navToAddShare{
    if(!self.spotModel){
        return;
    }
    DDSpotUserShareViewController *vc = [[DDSpotUserShareViewController alloc] init];
    vc.spotModel = self.spotModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadSpotData{
    [HttpUtil load:@"api/mdddetail.php"
            params:@{@"uuid" : self.spotInfo.uuid}
        completion:^(BOOL succ, NSString *message, id json) {
            [self loadingHidden];
            if(succ){
                NSError *error;
                self.spotModel = [[DDSpotDetailModel alloc] initWithDictionary:json error:&error];
                NSAssert(!error, @"%@", error);
                [self.headerView setModel:self.spotModel];
            }else{
                [RootViewController showAlert:message];
            }
        }];
}

- (void)loadMoreShareInfo{
    [HttpUtil load:@"api/pllist.php"
            params:@{@"uuid" : self.spotInfo.uuid,
                     @"offset" : @(self.pageno)}
        completion:^(BOOL succ, NSString *message, id json) {
            [self.tbList footerEndRefreshing];
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
                [self.shareHeaderView setShareCount:[json[@"total"] intValue]];
            }
        }];
}

- (void)btnClick_keepSpot{
    [HttpUtil load:@"apiupdate/updatepoifavor.php"
            params:@{}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                NSError *error;
                DDSpotDetailModel *detail = [[DDSpotDetailModel alloc] initWithDictionary:json error:&error];
                NSAssert(!error, @"%@", error);
                self.spotModel.favor = detail.favor;
                self.spotModel.hot = detail.hot;
                self.spotModel.favored = detail.favored;
                [self.headerView setModel:self.spotModel];
            }else{
                [RootViewController showAlert:message];
            }
        }];
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
    cell.worth = model.worth;
    cell.hasFavor = model.favored;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<DDShareInfoModel> item = self.shareList[indexPath.row];
    return [DDSpotShareTableViewCell heightForDetail:item.content];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.shareHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120;
}

#pragma mark - DDSpotShareTableViewCell Delegate
- (void)ddSpotShareCellFor:(DDShareInfoModel *)model selecteWorth:(DDSpotShareWorth)worth{
    [HttpUtil post:@"apiupdate/updateplworth.php"
            params:@{@"pl_uuid" : model.uuid,
                     @"type" : @(worth)}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                NSError *error;
                DDCustomShareInfoModel *item = [[DDCustomShareInfoModel alloc] initWithDictionary:json error:&error];
                NSInteger index = [self.shareList indexOfObject:model];
                [self.shareList replaceObjectAtIndex:index withObject:item];
                [self.tbList reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [RootViewController showAlert:message];
            }
        }];
}

- (void)ddSpotShareCellFor:(DDShareInfoModel *)model selecteFavor:(BOOL)favor{
    [HttpUtil post:@"apiupdate/updateplfavor.php"
            params:@{@"pl_uuid" : model.uuid,
                     @"type" : favor ? @(1) : @(0)}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                NSError *error;
                DDCustomShareInfoModel *item = [[DDCustomShareInfoModel alloc] initWithDictionary:json error:&error];
                NSInteger index = [self.shareList indexOfObject:model];
                [self.shareList replaceObjectAtIndex:index withObject:item];
                [self.tbList reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [RootViewController showAlert:message];
            }
        }];
}

#pragma mark - DDSpotDetailHeaderView Delegate
- (void)ddDetailHeaderViewDidSelectedFavorite{
    
}

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
    vc.title = [self.spotModel.title copy];
    vc.desc = self.spotModel.desc;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
