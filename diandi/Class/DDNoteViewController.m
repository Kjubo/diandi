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

@interface DDNoteViewController ()<UITableViewDelegate , UITableViewDataSource, DDTopMenuViewDelegate>
@property (nonatomic, strong) DDPopAreaView *popAreaView;
@property (nonatomic, strong) DDPopContainerView *popContainerView; //容器
@property (nonatomic, strong) DDTopMenuView *topView;          //搜索
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tbList;

@end

static NSString *kCellReuseIdentifier = @"kCellReuseIdentifier";
@implementation DDNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    self.topView = [DDTopMenuView new];
    self.topView.backgroundColor = GS_COLOR_MAIN;
    self.topView.delegate = self;
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@64);
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
    self.popAreaView.hidden = YES;
    self.popContainerView.hidden = YES;
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tbList){
        return 20;
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
