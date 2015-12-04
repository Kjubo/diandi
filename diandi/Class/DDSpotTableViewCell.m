//
//  DDSpotTableViewCell.m
//  diandi
//
//  Created by kjubo on 15/11/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotTableViewCell.h"
#import "DDRankView.h"
@interface DDSpotTableViewCell ()
@property (nonatomic, strong) UIImageView *ivSpotImage;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbSubTitle;
@property (nonatomic, strong) UILabel *lbKeepCount;
@property (nonatomic, strong) DDRankView *rankView;
@property (nonatomic, strong) UILabel *lbShareInfo;
@property (nonatomic, strong) UILabel *lbPoiType;
@end

@implementation DDSpotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.ivSpotImage = [UIImageView new];
        self.ivSpotImage.backgroundColor = GS_COLOR_LIGHTGRAY;
        [self.contentView addSubview:self.ivSpotImage];
        [self.ivSpotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 80));
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        UIView *keepView = [UIView new];
        [self.contentView addSubview:keepView];
        [keepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.ivSpotImage);
        }];
        
        UIImageView *iv_star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_star"]];
        [keepView addSubview:iv_star];
        [iv_star mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 14));
            make.left.equalTo(keepView).offset(5);
            make.top.equalTo(keepView).offset(5);
            make.bottom.equalTo(keepView).offset(-5);
        }];
        
        self.lbKeepCount = [UILabel new];
        self.lbKeepCount.textAlignment = NSTextAlignmentRight;
        self.lbKeepCount.backgroundColor = [UIColor clearColor];
        self.lbKeepCount.textColor = GS_COLOR_GRAY;
        self.lbKeepCount.font = [UIFont gs_font:NSAppFontS];
        [keepView addSubview:self.lbKeepCount];
        [self.lbKeepCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(keepView);
            make.left.equalTo(iv_star.mas_right).offset(5);
            make.right.equalTo(keepView);
        }];
        
        self.lbName = [UILabel new];
        self.lbName.backgroundColor = [UIColor clearColor];
        self.lbName.lineBreakMode = NSLineBreakByTruncatingTail;
        self.lbName.textColor = GS_COLOR_BLACK;
        self.lbName.font = [UIFont gs_font:NSAppFontM];
        [self.contentView addSubview:self.lbName];
        [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ivSpotImage.mas_right).offset(12);
            make.right.lessThanOrEqualTo(keepView.mas_left).offset(-10);
            make.top.equalTo(self.ivSpotImage).offset(4);
        }];
        
        self.rankView = [DDRankView new];
        [self.contentView addSubview:self.rankView];
        [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lbName);
            make.top.equalTo(self.lbName.mas_bottom).offset(8);
        }];
        
        self.lbSubTitle = [UILabel new];
        self.lbSubTitle.backgroundColor = [UIColor clearColor];
        self.lbSubTitle.textColor = GS_COLOR_DARKGRAY;
        self.lbSubTitle.font = [UIFont gs_font:NSAppFontS];
        [self.contentView addSubview:self.lbSubTitle];
        [self.lbSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lbName);
            make.bottom.equalTo(self.ivSpotImage.mas_bottom).offset(-4);
        }];
        
        self.lbShareInfo = [UILabel new];
        self.lbShareInfo.backgroundColor = [UIColor clearColor];
        self.lbShareInfo.lineBreakMode = NSLineBreakByTruncatingTail;
        self.lbShareInfo.textColor = GS_COLOR_GRAY;
        self.lbShareInfo.font = [UIFont gs_font:NSAppFontXS];
        [self.contentView addSubview:self.lbShareInfo];
        [self.lbShareInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.rankView);
            make.right.equalTo(keepView);
        }];
        
        self.lbPoiType = [UILabel new];
        self.lbPoiType.clipsToBounds = YES;
        self.lbPoiType.layer.cornerRadius = 4.0;
        self.lbPoiType.backgroundColor = HEXRGBCOLOR(0xAEE3FF);
        self.lbPoiType.textColor = GS_COLOR_DARKGRAY;
        self.lbPoiType.font = [UIFont gs_font:NSAppFontS];
        [self.contentView addSubview:self.lbPoiType];
        [self.lbPoiType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(keepView);
            make.centerY.equalTo(self.lbSubTitle);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = GS_COLOR_LIGHT;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@1);
        }];
    }
    return self;
}

- (void)setDataModel:(DDSpotModel *)data{
    [self.ivSpotImage sd_setImageWithURL:[NSURL URLWithString:data.img] placeholderImage:nil];
    self.lbName.text = [data.title copy];
    self.lbSubTitle.text = [data.subtitle copy];
    self.lbKeepCount.text = Int2String(data.favor);
    self.rankView.rank = data.hot;
    self.lbShareInfo.text = [NSString stringWithFormat:@"%@条分享", @(data.plnum)];
    self.lbPoiType.text = [data.poiType copy];
}
@end
