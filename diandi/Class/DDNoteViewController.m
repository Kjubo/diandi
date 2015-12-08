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
    
    [self loadingShow];
    [self loadMore];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
- (void)ddTopMenuViewDidSelected:(NSInteger)tag{
    if(tag == 0){
        self.popAreaView.hidden = !self.popAreaView.hidden;
        if(![self.popAreaView isHidden]){
            self.popContainerView.hidden = YES;
        }
    }else{
        self.popContainerView.hidden = !self.popContainerView.hidden;
        if(![self.popContainerView isHidden]){
            self.popAreaView.hidden = YES;
        }
    }
}

- (void)ddTopMenuViewDidCancelSelected{
    self.popContainerView.hidden = YES;
    self.popAreaView.hidden = YES;
}

- (void)ddTopMenuViewDidSearch{
    self.isSearching = !self.isSearching;
}

- (void)setIsSearching:(BOOL)isSearching{
    if(_isSearching == isSearching) return;
    _isSearching = isSearching;
    self.popAreaView.hidden = YES;
    self.popContainerView.hidden = YES;
    if(_isSearching){
        self.searchEmptyView.hidden = NO;
    }else{
        self.searchEmptyView.hidden = YES;
    }
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

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchBar.text length] == 0){
        self.searchEmptyView.hidden = NO;
    }else{
        self.searchEmptyView.hidden = YES;
    }
}

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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = GS_COLOR_WHITE;
            cell.textLabel.font = [UIFont gs_font:NSAppFontL];
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
            DDSpotDetailViewController *vc = [DDSpotDetailViewController new];
            vc.title = [item.title copy];
            vc.uuid = [item.uuid copy];
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
