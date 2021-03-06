//
//  DDSpotTableViewCell.m
//  diandi
//
//  Created by kjubo on 15/9/26.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDNoteTableViewCell.h"

@interface DDNoteTableViewCell ()
@property (nonatomic, strong) UIImageView *ivBackgroudImageView;
@property (nonatomic, strong) UIImageView *ivFaceView;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbDate;
@property (nonatomic, strong) UILabel *lbPersonCount;
@property (nonatomic, strong) UILabel *lbCost;
@property (nonatomic, strong) UILabel *lbKeepCount;

@end

@implementation DDNoteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.ivBackgroudImageView = [UIImageView new];
        self.ivBackgroudImageView.backgroundColor = GS_COLOR_LIGHTGRAY;
        [self.contentView addSubview:self.ivBackgroudImageView];
        [self.ivBackgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 5, 0));
        }];
        
        UIImageView *ic_date = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_date"]];
        [self.contentView addSubview:ic_date];
        [ic_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        self.lbDate = [UILabel new];
        self.lbDate.backgroundColor = [UIColor clearColor];
        self.lbDate.textColor = GS_COLOR_WHITE;
        self.lbDate.font = [UIFont gs_font:NSAppFontXS];
        [self.contentView addSubview:self.lbDate];
        [self.lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ic_date.mas_right).offset(2);
            make.centerY.equalTo(ic_date);
        }];
        
        UIImageView *ic_person = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_person"]];
        [self.contentView addSubview:ic_person];
        [ic_person mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.equalTo(self.lbDate.mas_right).offset(5);
            make.bottom.equalTo(ic_date);
        }];
        self.lbPersonCount = [UILabel new];
        self.lbPersonCount.backgroundColor = [UIColor clearColor];
        self.lbPersonCount.textColor = GS_COLOR_WHITE;
        self.lbPersonCount.font = [UIFont gs_font:NSAppFontS];
        [self.contentView addSubview:self.lbPersonCount];
        [self.lbPersonCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ic_person.mas_right).offset(2);
            make.centerY.equalTo(ic_person);
        }];
        
        UIImageView *ic_money = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_money"]];
        [self.contentView addSubview:ic_money];
        [ic_money mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.equalTo(self.lbPersonCount.mas_right).offset(5);
            make.bottom.equalTo(ic_date);
        }];
        self.lbCost = [UILabel new];
        self.lbCost.backgroundColor = [UIColor clearColor];
        self.lbCost.textColor = GS_COLOR_WHITE;
        self.lbCost.font = [UIFont gs_font:NSAppFontS];
        [self.contentView addSubview:self.lbCost];
        [self.lbCost mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ic_money.mas_right).offset(2);
            make.centerY.equalTo(ic_money);
        }];
        
        self.lbTitle = [UILabel new];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.textColor = GS_COLOR_WHITE;
        self.lbTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        self.lbTitle.font = [UIFont gs_font:NSAppFontM];
        [self.contentView addSubview:self.lbTitle];
        [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ic_date);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(ic_date.mas_top).offset(-5);
        }];
        
        
        self.ivFaceView = [UIImageView new];
        self.ivFaceView.layer.cornerRadius = 15;
        self.ivFaceView.clipsToBounds = YES;
        self.ivFaceView.layer.borderColor = GS_COLOR_WHITE.CGColor;
        self.ivFaceView.layer.borderWidth = 1;
        [self.contentView addSubview:self.ivFaceView];
        [self.ivFaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(self.lbTitle);
            make.bottom.equalTo(self.lbTitle.mas_top).offset(-5);
        }];
        
        self.lbName = [UILabel new];
        self.lbName.backgroundColor = [UIColor clearColor];
        self.lbName.textColor = GS_COLOR_WHITE;
        self.lbName.font = [UIFont gs_font:NSAppFontS];
        [self.contentView addSubview:self.lbName];
        [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ivFaceView.mas_right).offset(10);
            make.right.equalTo(self.lbTitle);
            make.centerY.equalTo(self.ivFaceView);
        }];
        
        UIView *keepView = [UIButton new];
        keepView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        keepView.layer.cornerRadius = 4.0;
        keepView.layer.borderWidth = 1.0;
        keepView.layer.borderColor = GS_COLOR_WHITE.CGColor;
        [self.contentView addSubview:keepView];
        [keepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.lbName);
            make.top.equalTo(self.contentView).offset(20);
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

- (void)setDataModel:(DDNoteModel *)data{
    self.lbName.text = [data.avaterName copy];
    self.lbTitle.text = [data.title copy];
    self.lbDate.text = [data.date copy];
    self.lbPersonCount.text = [data.suitperson copy];
    self.lbCost.text = [data.cost copy];
    self.lbKeepCount.text = Int2String(data.favor);
    [self.ivFaceView sd_setImageWithURL:[NSURL URLWithString:data.avaterImage] placeholderImage:nil];
    [self.ivBackgroudImageView sd_setImageWithURL:[NSURL URLWithString:data.previewImage] placeholderImage:nil];
}

@end
