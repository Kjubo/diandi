//
//  DDUserCenterViewController.m
//  diandi
//
//  Created by kjubo on 15/12/4.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDUserCenterViewController.h"
#import "DDUserSpotShareHeaderView.h"
#import "DDSpotShareTableViewCell.h"
#import "DDSpotWithShareListModel.h"
#import "MJRefresh.h"
#import "DDCacheHelper.h"
#import "DDSpotDetailViewController.h"

@interface DDUserCenterViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *ivFaceView;
@property (nonatomic, strong) UILabel *lbUserName;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *highlightLine;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UITableView *tbShareInfo;
@property (nonatomic, strong) UITableView *tbFavor;
@property (nonatomic, strong) UITableView *tbHistory;

@property (nonatomic) NSInteger typeIndex;              //tag的索引
@property (nonatomic) NSInteger myshareIndex;
@property (nonatomic) NSInteger myfavIndex;
@property (nonatomic, strong) NSMutableArray *lstMyShare;      //我的分享
@property (nonatomic, strong) NSMutableArray *lstMyFav;        //我的收藏
@end

#define kButtonTitles   @[@"我的分享", @"我的收藏", @"历史浏览"]
#define kButtonWidth    (DF_WIDTH/3.0)
static NSString *kHeaderFooterViewReuseIdentifier = @"kHeaderFooterViewReuseIdentifier";
static NSString *kShareCellReuseIdentifier = @"kShareCellReuseIdentifier";
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
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.highlightLine.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];

    self.tbShareInfo = [UITableView new];
    self.tbShareInfo.delegate = self;
    self.tbShareInfo.dataSource = self;
    self.tbShareInfo.separatorColor = [UIColor clearColor];
    self.tbShareInfo.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbShareInfo registerClass:[DDUserSpotShareHeaderView class] forHeaderFooterViewReuseIdentifier:kHeaderFooterViewReuseIdentifier];
    [self.tbShareInfo registerClass:[DDSpotShareTableViewCell class] forCellReuseIdentifier:kShareCellReuseIdentifier];
    [self.tbShareInfo addFooterWithTarget:self action:@selector(loadMoreShare)];
    [self.contentView addSubview:self.tbShareInfo];
    [self.tbShareInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentView);
        make.width.mas_equalTo(@(DF_WIDTH));
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
    }];
    
    self.tbFavor = [UITableView new];
    self.tbFavor.delegate = self;
    self.tbFavor.dataSource = self;
    self.tbFavor.separatorColor = [UIColor clearColor];
    self.tbFavor.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbFavor registerClass:[DDUserSpotShareHeaderView class] forHeaderFooterViewReuseIdentifier:kHeaderFooterViewReuseIdentifier];
    [self.tbFavor registerClass:[DDSpotShareTableViewCell class] forCellReuseIdentifier:kShareCellReuseIdentifier];
    [self.tbFavor addFooterWithTarget:self action:@selector(loadMoreFav)];
    [self.contentView addSubview:self.tbFavor];
    [self.tbFavor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(DF_WIDTH);
    }];
    
    self.tbHistory = [UITableView new];
    self.tbHistory.delegate = self;
    self.tbHistory.dataSource = self;
    self.tbHistory.separatorColor = [UIColor clearColor];
    self.tbHistory.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbHistory registerClass:[DDUserSpotShareHeaderView class] forHeaderFooterViewReuseIdentifier:kHeaderFooterViewReuseIdentifier];
    [self.contentView addSubview:self.tbHistory];
    [self.tbHistory  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(DF_WIDTH * 2);
    }];
    
    self.lstMyShare = [NSMutableArray array];
    self.lstMyFav = [NSMutableArray array];
    self.myshareIndex = 0;
    self.myfavIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.contentView.contentSize = CGSizeMake(DF_WIDTH * 3, self.contentView.height);
    if(self.typeIndex == -1){
        self.typeIndex = 0;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadMoreShare{
    if(self.myshareIndex == 0){
        [self loadingShow];
    }
    [HttpUtil load:@"api/myallpllist.php"
            params:@{@"offset" : @(self.myshareIndex)}
        completion:^(BOOL succ, NSString *message, id json) {
            [self.tbShareInfo footerEndRefreshing];
            if(succ){
                NSError *error;
                NSArray *lst = [DDSpotWithShareListModel arrayOfModelsFromDictionaries:json[@"list"] error:&error];
                NSAssert(!error, @"%@", error);
                if([lst count] > 0){
                    [self.lstMyShare addObjectsFromArray:lst];
                    [self.tbShareInfo reloadData];
                    self.myshareIndex = [self.lstMyShare count];
                }
                self.tbShareInfo.footerHidden = [json[@"islast"] boolValue];
            }else{
                [RootViewController showAlert:message];
            }
            [self loadingHidden];
        }];
    
}

- (void)loadMoreFav{
    if(self.myfavIndex == 0){
        [self loadingShow];
    }
    [HttpUtil load:@"api/myfavorlist.php"
            params:@{@"offset" : @(self.myfavIndex)}
        completion:^(BOOL succ, NSString *message, id json) {
            [self.tbFavor footerEndRefreshing];
            if(succ){
                NSError *error;
                NSArray *lst = [DDSpotWithShareListModel arrayOfModelsFromDictionaries:json[@"list"] error:&error];
                NSAssert(!error, @"%@", error);
                if([lst count] > 0){
                    [self.lstMyFav addObjectsFromArray:lst];
                    [self.tbFavor reloadData];
                    self.myfavIndex = [self.lstMyFav count];
                }
                self.tbFavor.footerHidden = [json[@"islast"] boolValue];
            }else{
                [RootViewController showAlert:message];
            }
            [self loadingHidden];
        }];
    
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
    [self.contentView setContentOffset:CGPointMake(DF_WIDTH * _typeIndex, 0) animated:YES];
    if(_typeIndex == 0 && [self.lstMyShare count] == 0){
        [self loadMoreShare];
    }else if(_typeIndex == 1 && [self.lstMyFav count] == 0){
        [self loadMoreFav];
    }else if(_typeIndex == 2){
        [self.tbHistory reloadData];
    }
}

#pragma mark - 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.typeIndex = scrollView.contentOffset.x/scrollView.width;
}

#pragma mark - UITableViewDelegate & Method
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 112;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbShareInfo
       || tableView == self.tbFavor){
        DDSpotWithShareListModel *spotItem = (tableView == self.tbShareInfo) ? self.lstMyShare[indexPath.section] : self.lstMyFav[indexPath.section];
        id<DDShareInfoModel> item = spotItem.pllist[indexPath.row];
        return [DDSpotShareTableViewCell heightForDetail:item.content];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.tbShareInfo){
        return [self.lstMyShare count];
    }else if(tableView == self.tbFavor){
        return [self.lstMyFav count];
    }else if(tableView == self.tbHistory){
        return [[DDCacheHelper shared].viewHistoryList count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tbShareInfo){
        DDSpotWithShareListModel *spotItem = self.lstMyShare[section];
        return [spotItem.pllist count];
    }else if(tableView == self.tbFavor){
        DDSpotWithShareListModel *spotItem = self.lstMyFav[section];
        return [spotItem.pllist count];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DDUserSpotShareHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderFooterViewReuseIdentifier];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderSection:)];
    [headerView addGestureRecognizer:tap];
    if(tableView == self.tbShareInfo){
        DDSpotWithShareListModel *spotItem = self.lstMyShare[section];
        [headerView setDataModel:spotItem showArrowLine:[spotItem.pllist count] > 0];
    }if(tableView == self.tbFavor){
        DDSpotWithShareListModel *spotItem = self.lstMyFav[section];
        [headerView setDataModel:spotItem showArrowLine:[spotItem.pllist count] > 0];
    }else if(tableView == self.tbHistory){
        DDSpotModel *spotItem = [DDCacheHelper shared].viewHistoryList[section];
        [headerView setDataModel:spotItem showArrowLine:NO];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbShareInfo){
        DDSpotShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShareCellReuseIdentifier forIndexPath:indexPath];
        DDSpotWithShareListModel *spotItem = self.lstMyShare[indexPath.section];
        DDCustomShareInfoModel *shareItem = spotItem.pllist[indexPath.row];
        [cell setModel:shareItem];
        cell.worth = shareItem.worth;
        cell.hasFavor = shareItem.favored;
        return cell;
    }else if(tableView == self.tbFavor){
        DDSpotShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShareCellReuseIdentifier forIndexPath:indexPath];
        DDSpotWithShareListModel *spotItem = self.lstMyFav[indexPath.section];
        DDCustomShareInfoModel *shareItem = spotItem.pllist[indexPath.row];
        [cell setModel:shareItem];
        cell.worth = shareItem.worth;
        cell.hasFavor = shareItem.favored;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id<DDSpotModel> spotItem = nil;
    if(tableView == self.tbShareInfo){
        spotItem = self.lstMyShare[indexPath.section];
    }if(tableView == self.tbFavor){
        spotItem = self.lstMyFav[indexPath.section];
    }else if(tableView == self.tbHistory){
        spotItem = [DDCacheHelper shared].viewHistoryList[indexPath.section];
    }
}

- (void)handleTapHeaderSection:(UITapGestureRecognizer *)sender{
    DDUserSpotShareHeaderView *header = (DDUserSpotShareHeaderView *)sender.view;
    DDSpotDetailViewController *vc = [DDSpotDetailViewController newSpotDetailViewController:header.spotModel];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIButton Click
- (void)btnClick_setting{
    
}

- (void)btnClick_changeType:(UIButton *)sender{
    self.typeIndex = sender.tag;
}


@end
