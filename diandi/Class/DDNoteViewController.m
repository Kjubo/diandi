//
//  DDSpotViewController.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDNoteViewController.h"
#import "DDPopAreaView.h"
#import "DDPopContainerView.h"
#import "DDGradeView.h"
#import "DDTopMenuView.h"
#import "DDSearchEmptyView.h"

#import "DDNoteTableViewCell.h"
#import "DDSpotTableViewCell.h"
#import "DDNoteModel.h"
#import "DDSpotModel.h"
#import "DDSpotDetailViewController.h"
#import "DDLinkageCell.h"
#import "MJRefresh.h"
#import "DDCacheHelper.h"

@interface DDNoteViewController ()<UITableViewDelegate , UITableViewDataSource, DDTopMenuViewDelegate, UISearchBarDelegate, DDPopAreaViewDelegate, DDSearchEmptyViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UISearchBar *searchBar;               //搜索框
@property (nonatomic, strong) DDTopMenuView *menuView;              //分类搜索
@property (nonatomic, strong) DDPopAreaView *popAreaView;
@property (nonatomic, strong) DDPopContainerView *popContainerView; //容器
@property (nonatomic, strong) DDSearchEmptyView *searchEmptyView;   //搜索关键字为空
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tbList;

@property (nonatomic) BOOL isSearching;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) NSString *areaUuid;
@property (nonatomic, strong) NSMutableArray *data;
@end

static NSString *kCellReuseIdentifier = @"kCellReuseIdentifier";
@implementation DDNoteViewController

- (instancetype)initWithNoteViewType:(DDNoteViewType)type{
    if(self = [super init]){
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topView = [UIView new];
    self.topView.backgroundColor = GS_COLOR_MAIN;
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@64);
    }];
    
    self.menuView = [DDTopMenuView new];
    self.menuView.delegate = self;
    [self.topView addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topView).insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];

    self.searchBar = [UISearchBar new];
    self.searchBar.hidden = YES;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.placeholder = @"请输入搜索关键字~";
    self.searchBar.barTintColor = GS_COLOR_MAIN;
    self.searchBar.backgroundImage = [UIImage new];
    [self.topView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.menuView);
    }];
    
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    
    self.tbList = [UITableView new];
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbList addHeaderWithTarget:self action:@selector(refreshData)];
    [self.tbList addFooterWithTarget:self action:@selector(loadMore)];
    [self.containerView addSubview:self.tbList];
    [self.tbList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    self.popAreaView = [DDPopAreaView new];
    self.popAreaView.delegate = self;
    [self.containerView addSubview:self.popAreaView];
    [self.popAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    self.popContainerView = [DDPopContainerView new];
    self.popContainerView.tableViewDelegate = self;
    self.popContainerView.tableViewDataSource = self;
    [self.containerView addSubview:self.popContainerView];
    [self.popContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    self.searchEmptyView = [DDSearchEmptyView new];
    self.searchEmptyView.delegate = self;
    [self.containerView addSubview:self.searchEmptyView];
    [self.searchEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    if(_type == DDNoteView_Note){
        [self.tbList registerClass:[DDNoteTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    }else if(_type == DDNoteView_Spot){
        [self.tbList registerClass:[DDSpotTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    }
    
    self.pageIndex = 0;
    self.data = [NSMutableArray array];
    
    [self initRAC];
    [self loadingShow];
    [self loadMore];
   
}

- (void)initRAC{
    //取消TopMenu的选中状态
    [[RACSignal combineLatest:@[RACObserve(self.popAreaView, hidden), RACObserve(self.popContainerView, hidden)]
                      reduce:^id(NSNumber *hidden1, NSNumber *hidden2){
                          return @([hidden1 boolValue] && [hidden2 boolValue]);
                      }] subscribeNext:^(id x) {
                          if([x boolValue]){
                              self.menuView.menuType = DDTopMenuTypeNone;
                          }
                      }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)refreshData{
    self.pageIndex = 0;
    [self loadMore];
}

- (void)loadMore{
    NSString *uri = @"ddy/poisearch.php";
    if(_type == DDNoteView_Spot){
        uri = @"api/mddlistsearch.php";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"offset" : @(self.pageIndex),
                                                                                  @"pagenum" : @(10)}];
    if(self.areaUuid){
        [params setObject:self.areaUuid forKey:@"uuid"];
    }
    [HttpUtil load:uri params:params
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                [self.tbList headerEndRefreshing];
                [self.tbList footerEndRefreshing];
                NSError *error;
                NSArray *items;
                if(_type == DDNoteView_Note){
                    items = [DDNoteModel arrayOfModelsFromDictionaries:json[@"list"] error:&error];
                }else{
                    items = [DDSpotModel arrayOfModelsFromDictionaries:json[@"list"] error:&error];
                }
                NSAssert(!error, @"%@", error);
                if([items count] > 0){
                    if(self.pageIndex == 0){
                        [self.data removeAllObjects];
                    }
                    [self.data addObjectsFromArray:items];
                    self.pageIndex = MAX(0, [self.data count] - 1);
                    [self.tbList reloadData];
                }
                if([json[@"islast"] boolValue]){
                    [self.tbList setFooterHidden:YES];
                }else{
                    [self.tbList setFooterHidden:NO];
                }
            }else{
                [RootViewController showAlert:message];
            }
            [self loadingHidden];
        }];
}

#pragma mark - DDPopAreaViewDelegate
- (void)ddPopAreaViewDidSelected:(DDArea *)data{
    self.areaUuid = [data.uuid copy];
    self.pageIndex = 0;
    [self loadingShow];
    [self loadMore];
}

#pragma mark - DDTopMenuView Delegate
- (void)ddTopMenuViewDidSelected:(DDTopMenuType)type{
    if(type == DDTopMenuTypeArea){
        self.popAreaView.hidden = NO;
    }else if(type == DDTopMenuTypeSearch){
        self.isSearching = YES;
    }else{
        self.popContainerView.hidden = NO;
    }
}

- (void)ddTopMenuViewDidCancel:(DDTopMenuType)type{
    if(type == DDTopMenuTypeArea){
        self.popAreaView.hidden = YES;
    }else if(type == DDTopMenuTypeSearch){
        self.isSearching = NO;
    }else{
        self.popContainerView.hidden = YES;
    }
}

- (void)setIsSearching:(BOOL)isSearching{
    if(_isSearching == isSearching) return;
    _isSearching = isSearching;
    [UIView transitionWithView:self.topView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.menuView.hidden = _isSearching;
        self.searchBar.hidden = !_isSearching;
    } completion:^(BOOL finished) {
        if([self.searchBar isHidden]){
            [self.searchBar resignFirstResponder];
        }else{
            [self.searchBar becomeFirstResponder];
        }
    }];
}

#pragma mark - DDSearchEmptyViewDelegate
- (void)ddSearchEmptyViewDidSelect:(NSString *)searchKey{
    if([searchKey length] == 0){
        return;
    }
    self.searchBar.text = [searchKey copy];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text = nil;
    self.isSearching = NO;
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tbList){
        return [self.data count];
    }else{
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbList){
        if(_type == DDNoteView_Spot){
            return 112;
        }else{
            return 9.0/15.0 * DF_WIDTH + 10.0;
        }
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbList){
        if(_type == DDNoteView_Note){
            DDNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
            DDNoteModel *item = self.data[indexPath.row];
            [cell setDataModel:item];
            return cell;
        }else{
            DDSpotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
            DDSpotModel *item = self.data[indexPath.row];
            [cell setDataModel:item];
            return cell;
        }
    }else{
        DDLinkageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
        if(!cell){
            cell = [[DDLinkageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReuseIdentifier];
        }
        cell.textLabel.text = @"分类内容";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbList){
        if(_type == DDNoteView_Note){

        }else{
            DDSpotModel *item = self.data[indexPath.row];
            DDSpotDetailViewController *vc = [DDSpotDetailViewController newSpotDetailViewController:item];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITabBar
- (BOOL)hidesBottomBarWhenPushed
{
    return (self.navigationController.topViewController != self);
}


@end
