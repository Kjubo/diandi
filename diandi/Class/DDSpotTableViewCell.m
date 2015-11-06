//
//  DDSpotTableViewCell.m
//  diandi
//
//  Created by kjubo on 15/11/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotTableViewCell.h"

@interface DDSpotTableViewCell ()
@property (nonatomic, strong) UIImageView *ivSpotImage;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbSubTitle;
@property (nonatomic, strong) UIImageView *ivSpotType;
@property (nonatomic, strong) UILabel *lbKeepCount;
@end

@implementation DDSpotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.ivSpotImage = [UIImageView new];
        [self.contentView addSubview:self.ivSpotImage];
        [self.ivSpotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 75));
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        self.lbName = [UILabel new];
        self.lbName.backgroundColor = [UIColor clearColor];
        self.lbName.textColor = GS_COLOR_BLACK;
        self.lbName.font = [UIFont gs_boldfont:NSAppFontM];
        [self.contentView addSubview:self.lbName];
        [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ivSpotImage.mas_right).offset(15);
            make.top.equalTo(self.ivSpotImage);
        }];
        
        self.lbSubTitle = [UILabel new];
        self.lbSubTitle.backgroundColor = [UIColor clearColor];
        self.lbSubTitle.textColor = GS_COLOR_GRAY;
        self.lbSubTitle.font = [UIFont gs_font:NSAppFontS];
        [self.contentView addSubview:self.lbSubTitle];
        [self.lbSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lbName);
            make.top.equalTo(self.lbName.mas_bottom).offset(2);
        }];
        
        self.ivSpotType = [UIImageView new];
        self.ivSpotType.clipsToBounds = YES;
        self.ivSpotImage.backgroundColor = GS_COLOR_LIGHTGRAY;
        self.ivSpotType.layer.cornerRadius = 20.0;
        [self.contentView addSubview:self.ivSpotType];
        [self.ivSpotType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self.ivSpotImage);
            make.right.equalTo(self.contentView).offset(-20);
        }];
        
        UIView *keepView = [UIButton new];
        keepView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        keepView.layer.cornerRadius = 4.0;
        keepView.layer.borderWidth = 1.0;
        keepView.layer.borderColor = GS_COLOR_WHITE.CGColor;
        [self.contentView addSubview:keepView];
        [keepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.ivSpotType);
            make.top.equalTo(self.ivSpotType.mas_bottom).offset(2);
        }];
        
        UIImageView *iv_star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_star_hl"]];
        [keepView addSubview:iv_star];
        [iv_star mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 14));
            make.left.equalTo(keepView).offset(5);
            make.top.equalTo(keepView).offset(5);
            make.bottom.equalTo(keepView).offset(-5);
        }];
        
        self.lbKeepCount = [UILabel new];
        self.lbKeepCount.backgroundColor = [UIColor clearColor];
        self.lbKeepCount.textColor = GS_COLOR_WHITE;
        self.lbKeepCount.font = [UIFont gs_font:NSAppFontS];
        [keepView addSubview:self.lbKeepCount];
        [self.lbKeepCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(keepView);
            make.left.equalTo(iv_star.mas_right).offset(5);
            make.right.equalTo(keepView).offset(-5);
        }];
    }
    return self;
}

- (void)setDataModel:(DDSpotModel *)data{
    [self.ivSpotImage sd_setImageWithURL:[NSURL URLWithString:data.img] placeholderImage:nil];
    self.lbName.text = [data.title copy];
}
@end
