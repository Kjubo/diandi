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
#import "DDNoteTableViewCell.h"
#import "DDSpotModel.h"
#import "MJRefresh.h"

@interface DDNoteViewController ()<UITableViewDelegate , UITableViewDataSource, DDTopMenuViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) DDPopAreaView *popAreaView;
@property (nonatomic, strong) DDPopContainerView *popContainerView; //容器
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UISearchBar *searchBar;               //搜索框
@property (nonatomic, strong) DDTopMenuView *menuView;               //分类搜索
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tbList;

@property (nonatomic) BOOL isSearching;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *data;
@end

static NSString *kCellReuseIdentifier = @"kCellReuseIdentifier";
@implementation DDNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    self.topView = [UIView new];
    self.topView.backgroundColor = GS_COLOR_BLACK;
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
    self.searchBar.barTintColor = GS_COLOR_BLACK;
    self.searchBar.backgroundColor = [UIColor clearColor];
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
    [self.tbList registerClass:[DDNoteTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    [self.containerView addSubview:self.tbList];
    [self.tbList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    [self.tbList addHeaderWithTarget:self action:@selector(refreshData)];
    
    self.popAreaView = [DDPopAreaView new];
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
    
    self.pageIndex = 0;
    self.data = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadingShow];
    [self loadMore];
}

- (void)refreshData{
    self.pageIndex = 0;
    [self loadMore];
}

- (void)loadMore{
    [HttpUtil load:@"poisearch.php" params:@{@"country" : @"中国",
                                             @"city" : @"上海",
                                             @"area" : @"亚洲",
                                             @"offset" : @(self.pageIndex),
                                             @"pagenum" : @(10)}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                [self.tbList footerEndRefreshing];
                [self.tbList headerEndRefreshing];
                NSError *error;
                NSArray *items = [DDSpotModel arrayOfModelsFromDictionaries:json[@"list"] error:&error];
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

- (void)ddTopMenuViewDidSearch{
    self.isSearching = !self.isSearching;
}

- (void)setIsSearching:(BOOL)isSearching{
    if(_isSearching == isSearching) return;
    _isSearching = isSearching;
    if(_isSearching){
        self.popAreaView.hidden = YES;
        self.popContainerView.hidden = YES;
        
        
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
        return 9.0/15.0 * DF_WIDTH + 10.0;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbList){
        DDNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
        DDSpotModel *item = self.data[indexPath.row];
        [cell setDateModel:item];
        return cell;
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



@end
