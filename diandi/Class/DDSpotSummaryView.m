//
//  DDSpotSummaryView.m
//  diandi
//
//  Created by kjubo on 15/12/4.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotSummaryView.h"
#import "DDRankView.h"
@interface DDSpotSummaryView()
@property (nonatomic, strong) UIImageView *ivSpotImage;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbSubTitle;
@property (nonatomic, strong) UILabel *lbKeepCount;
@property (nonatomic, strong) DDRankView *rankView;
@property (nonatomic, strong) UILabel *lbShareInfo;
@property (nonatomic, strong) UILabel *lbPoiType;
@end

@implementation DDSpotSummaryView

- (instancetype)init{
    if(self = [super init]){
        self.ivSpotImage = [UIImageView new];
        self.ivSpotImage.backgroundColor = GS_COLOR_LIGHTGRAY;
        [self addSubview:self.ivSpotImage];
        [self.ivSpotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 80));
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
        UIView *keepView = [UIView new];
        [self addSubview:keepView];
        [keepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
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
        [self addSubview:self.lbName];
        [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ivSpotImage.mas_right).offset(12);
            make.right.lessThanOrEqualTo(keepView.mas_left).offset(-10);
            make.top.equalTo(self.ivSpotImage).offset(4);
        }];

        self.rankView = [DDRankView new];
        [self addSubview:self.rankView];
        [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lbName);
            make.top.equalTo(self.lbName.mas_bottom).offset(8);
        }];
        
        self.lbSubTitle = [UILabel new];
        self.lbSubTitle.backgroundColor = [UIColor clearColor];
        self.lbSubTitle.textColor = GS_COLOR_DARKGRAY;
        self.lbSubTitle.font = [UIFont gs_font:NSAppFontS];
        [self addSubview:self.lbSubTitle];
        [self.lbSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lbName);
            make.bottom.equalTo(self.ivSpotImage.mas_bottom).offset(-4);
        }];

        self.lbShareInfo = [UILabel new];
        self.lbShareInfo.backgroundColor = [UIColor clearColor];
        self.lbShareInfo.lineBreakMode = NSLineBreakByTruncatingTail;
        self.lbShareInfo.textColor = GS_COLOR_GRAY;
        self.lbShareInfo.font = [UIFont gs_font:NSAppFontXS];
        [self addSubview:self.lbShareInfo];
        [self.lbShareInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.ivSpotImage);
            make.right.equalTo(keepView);
        }];
        
        self.lbPoiType = [UILabel new];
        self.lbPoiType.clipsToBounds = YES;
        self.lbPoiType.layer.cornerRadius = 4.0;
        self.lbPoiType.backgroundColor = HEXRGBCOLOR(0xAEE3FF);
        self.lbPoiType.textColor = GS_COLOR_DARKGRAY;
        self.lbPoiType.font = [UIFont gs_font:NSAppFontS];
        [self addSubview:self.lbPoiType];
        [self.lbPoiType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(keepView);
            make.centerY.equalTo(self.lbSubTitle);
        }];
    }
    return self;
}

- (void)setDataModel:(id<DDSpotModel>)data{
    [self.ivSpotImage sd_setImageWithURL:[NSURL URLWithString:data.img] placeholderImage:nil];
    self.lbName.text = [data.title copy];
    self.lbSubTitle.text = [data.subtitle copy];
    self.lbKeepCount.text = Int2String(data.favor);
    self.rankView.rank = data.hot;
    self.lbShareInfo.text = [NSString stringWithFormat:@"%@条分享", @(data.plnum)];
}


@end
