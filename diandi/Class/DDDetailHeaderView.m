//
//  DDDetailHeaderView.m
//  diandi
//
//  Created by kjubo on 15/11/18.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDDetailHeaderView.h"
#import "DDRankView.h"

@interface DDDetailHeaderView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *ivSpotImage;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbSubTitle;
@property (nonatomic, strong) UIButton *btnKeep;
@property (nonatomic, strong) DDRankView *rankView;
@property (nonatomic, strong) UILabel *lbShareInfo;
@property (nonatomic, strong) UITableView *tbSpotInfo;

@property (nonatomic, strong) NSArray *tbSources;
@end

#define kSpotInfoIconNames      @[@"ic_location", @"ic_phone", @"ic_time"]
static NSString *kSpotInfoCellIdentifier = @"kSpotInfoCellIdentifier";
@implementation DDDetailHeaderView

- (instancetype)init{
    if(self = [super init]){
        self.ivSpotImage = [UIImageView new];
        self.ivSpotImage.backgroundColor = GS_COLOR_LIGHT;
        [self addSubview:self.ivSpotImage];
        [self.ivSpotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.equalTo(self);
            make.height.equalTo(self.ivSpotImage.mas_width).dividedBy(375.0/180.0);
        }];
        
        self.lbName = [UILabel new];
        self.lbName.backgroundColor = [UIColor clearColor];
        self.lbName.textColor = GS_COLOR_BLACK;
        self.lbName.font = [UIFont gs_font:NSAppFontM];
        [self addSubview:self.lbName];
        [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ivSpotImage.mas_bottom).offset(10);
            make.left.equalTo(self).offset(20);
        }];
        
        self.lbSubTitle = [UILabel new];
        self.lbSubTitle.backgroundColor = [UIColor clearColor];
        self.lbSubTitle.textColor = GS_COLOR_LIGHTGRAY;
        self.lbSubTitle.font = [UIFont gs_font:NSAppFontXS];
        [self addSubview:self.lbSubTitle];
        [self.lbSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lbName.mas_right).offset(10);
            make.bottom.equalTo(self.lbName);
        }];
        
        self.btnKeep = [UIButton new];
        [self.btnKeep addTarget:self action:@selector(btnClick_keepSpot) forControlEvents:UIControlEventTouchUpInside];
        [self.btnKeep setImage:[UIImage imageNamed:@"ic_star"] forState:UIControlStateNormal];
        [self.btnKeep setTitle:@"收藏" forState:UIControlStateNormal];
        [self addSubview:self.btnKeep];
        [self.btnKeep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 30));
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self.lbName);
        }];
        
        self.rankView = [DDRankView new];
        [self addSubview:self.rankView];
        [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lbName);
            make.top.equalTo(self.lbName.mas_bottom).offset(6);
        }];
        
        self.lbShareInfo = [UILabel new];
        self.lbShareInfo.backgroundColor = [UIColor clearColor];
        self.lbShareInfo.textColor = GS_COLOR_LIGHTGRAY;
        self.lbShareInfo.font = [UIFont gs_font:NSAppFontXS];
        [self addSubview:self.lbShareInfo];
        [self.lbShareInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rankView.mas_right).offset(10);
            make.centerY.equalTo(self.rankView);
        }];
        
        UILabel *lbInfoHeader = [UILabel new];
        lbInfoHeader.backgroundColor = [UIColor clearColor];
        lbInfoHeader.textColor = GS_COLOR_LIGHTGRAY;
        lbInfoHeader.text = @" ";
        lbInfoHeader.font = [UIFont gs_font:NSAppFontS];
        [self addSubview:lbInfoHeader];
        [lbInfoHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lbName);
            make.top.equalTo(self.rankView.mas_bottom).offset(20);
        }];
        
        self.tbSpotInfo = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.tbSpotInfo.backgroundColor = GS_COLOR_WHITE;
        self.tbSpotInfo.scrollEnabled = NO;
        self.tbSpotInfo.delegate = self;
        self.tbSpotInfo.dataSource = self;
        self.tbSpotInfo.rowHeight = 44;
        self.tbSpotInfo.separatorColor = GS_COLOR_LIGHTGRAY;
        self.tbSpotInfo.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tbSpotInfo.tableFooterView = [UIView new];
        [self.tbSpotInfo setSeparatorInset:UIEdgeInsetsZero];
        if ([self.tbSpotInfo respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tbSpotInfo setLayoutMargins:UIEdgeInsetsZero];
        }
        [self.tbSpotInfo registerClass:[UITableViewCell class] forCellReuseIdentifier:kSpotInfoCellIdentifier];
        [self addSubview:self.tbSpotInfo];
        [self.tbSpotInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(lbInfoHeader.mas_bottom).offset(10);
            make.height.mas_equalTo(44 * 5 + 10.0);
        }];
    }
    return self;
}

- (void)setIsFavorite:(BOOL)isFavorite{
    _isFavorite = isFavorite;
    if(_isFavorite){
        [self.btnKeep setImage:[UIImage imageNamed:@"ic_star_hl"] forState:UIControlStateNormal];
        [self.btnKeep setTitleColor:GS_COLOR_ORANGE forState:UIControlStateNormal];
    }else{
        [self.btnKeep setImage:[UIImage imageNamed:@"ic_star"] forState:UIControlStateNormal];
        [self.btnKeep setTitleColor:GS_COLOR_GRAY forState:UIControlStateNormal];
    }
}

- (void)setSpotModel:(DDSpotModel *)model{
    if(model){
        [self.ivSpotImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
        self.lbName.text = [model.title copy];
        self.lbSubTitle.textColor = [model.subtitle copy];
        self.rankView.rank = 3.8;
        self.lbShareInfo.text = [NSString stringWithFormat:@"%@个分享信息", @(234)];
        self.tbSources = @[@[@"亚洲 东京 西门汀45目", @"+03 072 45782332", @"上午9点-晚上10点"], @[@"景点信息", @"景点信息景点信息景点信息景点信息景点信息景点信息景点信息景点信息景点信息景点信息景点信息"]];
    }
}

- (void)btnClick_keepSpot{
    if([self.delegate respondsToSelector:@selector(ddDetailHeaderViewDidSelectedFavorite)]){
        [self.delegate ddDetailHeaderViewDidSelectedFavorite];
    }
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 && indexPath.row == 1){
        return 60;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 10;
    }
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 3;
    }else if(section == 1){
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpotInfoCellIdentifier forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:kSpotInfoIconNames[indexPath.row]];
        cell.textLabel.text = self.tbSources[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont gs_font:NSAppFontM];
        cell.textLabel.textColor = GS_COLOR_BLACK;
        if(indexPath.row <= 1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSpotInfoCellIdentifier forIndexPath:indexPath];
        cell.imageView.image = nil;
        cell.textLabel.text = self.tbSources[indexPath.section][indexPath.row];
        cell.textLabel.textColor = GS_COLOR_BLACK;
        if(indexPath.row == 0){
            cell.textLabel.font = [UIFont gs_font:NSAppFontL];
            cell.textLabel.numberOfLines = 1;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.font = [UIFont gs_font:NSAppFontS];
            cell.textLabel.numberOfLines = 2;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    return nil;
}

@end
