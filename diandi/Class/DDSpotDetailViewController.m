//
//  DDSpotDetailViewController.m
//  diandi
//
//  Created by kjubo on 15/11/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotDetailViewController.h"
#import "DDRankView.h"
@interface DDSpotDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIImageView *ivSpotImage;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbSubTitle;
@property (nonatomic, strong) UIButton *btnKeep;
@property (nonatomic, strong) DDRankView *rankView;
@property (nonatomic, strong) UILabel *lbShareInfo;
@property (nonatomic, strong) UITableView *tbSpotInfo;
@property (nonatomic) BOOL hasKeep;
@end

#define kSpotInfoIconNames      @[@"ic_location", @"ic_phone", @"ic_time"]
static NSString *kSpotInfoCellIdentifier = @"kSpotInfoCellIdentifier";

@implementation DDSpotDetailViewController

- (void)viewDidLoad{
    self.contentView = [UIScrollView new];
    self.contentView.backgroundColor = GS_COLOR_BACKGROUND;
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.width.equalTo(self.view);
    }];
    
    self.ivSpotImage = [UIImageView new];
    self.ivSpotImage.backgroundColor = GS_COLOR_LIGHT;
    [self.contentView addSubview:self.ivSpotImage];
    [self.ivSpotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self.contentView);
        make.height.equalTo(self.ivSpotImage.mas_width).dividedBy(375.0/180.0);
    }];
    
    self.lbName = [UILabel new];
    self.lbName.backgroundColor = [UIColor clearColor];
    self.lbName.textColor = GS_COLOR_BLACK;
    self.lbName.font = [UIFont gs_font:NSAppFontM];
    [self.contentView addSubview:self.lbName];
    [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ivSpotImage.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(20);
    }];
    
    self.lbSubTitle = [UILabel new];
    self.lbSubTitle.backgroundColor = [UIColor clearColor];
    self.lbSubTitle.textColor = GS_COLOR_LIGHTGRAY;
    self.lbSubTitle.font = [UIFont gs_font:NSAppFontXS];
    [self.contentView addSubview:self.lbSubTitle];
    [self.lbSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbName.mas_right).offset(10);
        make.bottom.equalTo(self.lbName);
    }];
    
    self.btnKeep = [UIButton new];
    [self.btnKeep addTarget:self action:@selector(btnClick_keepSpot) forControlEvents:UIControlEventTouchUpInside];
    [self.btnKeep setImage:[UIImage imageNamed:@"ic_star"] forState:UIControlStateNormal];
    [self.btnKeep setTitle:@"收藏" forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnKeep];
    [self.btnKeep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.lbName);
    }];
    
    self.rankView = [DDRankView new];
    [self.contentView addSubview:self.rankView];
    [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbName);
        make.top.equalTo(self.lbName.mas_bottom).offset(6);
    }];
    
    self.lbShareInfo = [UILabel new];
    self.lbShareInfo.backgroundColor = [UIColor clearColor];
    self.lbShareInfo.textColor = GS_COLOR_LIGHTGRAY;
    self.lbShareInfo.font = [UIFont gs_font:NSAppFontXS];
    [self.contentView addSubview:self.lbShareInfo];
    [self.lbShareInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rankView.mas_right).offset(10);
        make.centerY.equalTo(self.rankView);
    }];
    
    UILabel *lbInfoHeader = [UILabel new];
    lbInfoHeader.backgroundColor = [UIColor clearColor];
    lbInfoHeader.textColor = GS_COLOR_LIGHTGRAY;
    lbInfoHeader.text = @"景点信息";
    lbInfoHeader.font = [UIFont gs_font:NSAppFontS];
    [self.contentView addSubview:lbInfoHeader];
    [lbInfoHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbName);
        make.top.equalTo(self.rankView.mas_bottom).offset(20);
    }];
    
    self.tbSpotInfo = [UITableView new];
    self.tbSpotInfo.backgroundColor = GS_COLOR_WHITE;
    self.tbSpotInfo.scrollEnabled = NO;
    self.tbSpotInfo.delegate = self;
    self.tbSpotInfo.dataSource = self;
    self.tbSpotInfo.rowHeight = 44;
    self.tbSpotInfo.separatorColor = GS_COLOR_LIGHTGRAY;
    self.tbSpotInfo.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tbSpotInfo setSeparatorInset:UIEdgeInsetsZero];
    if ([self.tbSpotInfo respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tbSpotInfo setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tbSpotInfo registerClass:[UITableViewCell class] forCellReuseIdentifier:kSpotInfoCellIdentifier];
    [self.contentView addSubview:self.tbSpotInfo];
    [self.tbSpotInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.top.equalTo(lbInfoHeader.mas_bottom).offset(10);
        make.height.mas_equalTo(44 * 3);
    }];
    
    if(self.spotModel){
        [self.ivSpotImage sd_setImageWithURL:[NSURL URLWithString:self.spotModel.img] placeholderImage:nil];
        self.lbName.text = [self.spotModel.title copy];
        self.lbSubTitle.textColor = [self.spotModel.subtitle copy];
        self.rankView.rank = 3.8;
        self.lbShareInfo.text = [NSString stringWithFormat:@"%@个分享信息", @(234)];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)btnClick_keepSpot{
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.tbSpotInfo == tableView){
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.tbSpotInfo == tableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpotInfoCellIdentifier forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:kSpotInfoIconNames[indexPath.row]];
        cell.textLabel.text = @"12314";
        cell.textLabel.font = [UIFont gs_font:NSAppFontM];
        cell.textLabel.textColor = GS_COLOR_BLACK;
        return cell;
    }
    return nil;
}

@end
