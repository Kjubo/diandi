//
//  DDSpotShareTableViewCell.m
//  diandi
//
//  Created by kjubo on 15/11/18.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotShareTableViewCell.h"

@interface DDSpotShareTableViewCell ()
@property (nonatomic, strong) UIImageView *ivType;
@property (nonatomic, strong) UILabel *lbDetail;
@property (nonatomic, strong) UIImageView *ivFaceView;
@property (nonatomic, strong) UILabel *lbPoster;
@property (nonatomic, strong) NSMutableArray *buttons;

@end

#define kPreferredMaxLayoutWidth (DF_WIDTH - 30.0)
#define kShareTypeIconNames @[@"photo", @"car", @"suitcase", @"next", @"talk"]
@implementation DDSpotShareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.ivType = [UIImageView new];
        self.ivType.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.ivType];
        [self.ivType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.top.equalTo(self.contentView).offset(15);
        }];
        
        self.ivFaceView = [UIImageView new];
        self.ivFaceView.clipsToBounds = YES;
        self.ivFaceView.layer.cornerRadius = 10.0;
        [self.contentView addSubview:self.ivFaceView];
        [self.ivFaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).priority(250);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.top.equalTo(self.ivType);
        }];
    
        self.lbPoster = [UILabel new];
        self.lbPoster.backgroundColor = [UIColor clearColor];
        self.lbPoster.textColor = GS_COLOR_WHITE;
        self.lbPoster.font = [UIFont gs_font:NSAppFontS];
        [self.contentView addSubview:self.lbPoster];
        [self.lbPoster mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).priority(500);
            make.centerY.equalTo(self.ivFaceView);
            make.left.equalTo(self.ivFaceView.mas_right).offset(4);
        }];
        
        self.lbDetail = [UILabel new];
        self.lbDetail.backgroundColor = [UIColor clearColor];
        self.lbDetail.textColor = GS_COLOR_BLACK;
        self.lbDetail.font = [UIFont gs_font:NSAppFontM];
        self.lbDetail.numberOfLines = 0;
        self.lbDetail.lineBreakMode = NSLineBreakByWordWrapping;
        self.lbDetail.preferredMaxLayoutWidth = kPreferredMaxLayoutWidth;
        [self.contentView addSubview:self.lbDetail];
        [self.lbDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ivFaceView.mas_bottom).offset(6);
            make.left.equalTo(self.ivType.mas_right).offset(6);
            make.right.equalTo(self.lbPoster);
        }];
        
        
        CGFloat buttonWidth = DF_WIDTH/3.0;
        for(int i = 0; i < 3; i++){
            UIButton *btn = [UIButton new];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont gs_font:NSAppFontM];
            [self.contentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(buttonWidth, 30));
                make.left.mas_equalTo(@(buttonWidth * i));
                make.bottom.equalTo(self.contentView).offset(-6);
            }];
            
            if(i <= 1){
                UIView *line = [UIView new];
                line.backgroundColor = GS_COLOR_LIGHTGRAY;
                [self.contentView addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(btn.mas_right);
                    make.height.equalTo(btn.mas_height).offset(-4);
                    make.centerY.equalTo(btn);
                    make.width.mas_equalTo(@1);
                }];
            }
        }
    }
    return self;
}

- (void)setModel:(DDShareInfoModel *)model{
    _model = model;
    self.goodCount = model.goodCount;
    self.badCount = model.badCount;
    self.favorCount = model.favorCount;
    self.ivType.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_share_%@", kShareTypeIconNames[_model.shareType]]];
    [self.ivFaceView sd_setImageWithURL:[NSURL URLWithString:_model.avaterImage] placeholderImage:nil];
    self.lbPoster.text = [NSString stringWithFormat:@"%@  %@", _model.avaterName, _model.postDate];
    self.lbDetail.text = [_model.content copy];
}

- (void)setGoodCount:(BOOL)goodCount{
    _goodCount = goodCount;
    UIButton *btn = self.buttons[0];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"有用" attributes:@{NSForegroundColorAttributeName : GS_COLOR_BLACK}];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@)", @(_goodCount)] attributes:@{NSForegroundColorAttributeName : GS_COLOR_LIGHTGRAY}]];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)setBadCount:(BOOL)badCount{
    _badCount = badCount;
    UIButton *btn = self.buttons[1];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"没用" attributes:@{NSForegroundColorAttributeName : GS_COLOR_BLACK}];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@)", @(_badCount)] attributes:@{NSForegroundColorAttributeName : GS_COLOR_LIGHTGRAY}]];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)setFavorCount:(BOOL)favorCount{
    _favorCount = favorCount;
    UIButton *btn = self.buttons[2];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"收藏" attributes:@{NSForegroundColorAttributeName : GS_COLOR_BLACK}];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@)", @(_favorCount)] attributes:@{NSForegroundColorAttributeName : GS_COLOR_LIGHTGRAY}]];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)setWorth:(DDSpotShareWorth)worth{
    _worth = worth;
    UIButton *btnGood = self.buttons[0];
    UIButton *btnBad = self.buttons[1];
    if(worth == DDSpotShareWorthNone){
        [btnGood setImage:[UIImage imageNamed:@"ic_useful"] forState:UIControlStateNormal];
        [btnBad setImage:[UIImage imageNamed:@"ic_nouseful"] forState:UIControlStateNormal];
    }else if(worth == DDSpotShareWorthGood){
        [btnGood setImage:[UIImage imageNamed:@"ic_useful_hl"] forState:UIControlStateNormal];
        [btnBad setImage:[UIImage imageNamed:@"ic_nouseful"] forState:UIControlStateNormal];
    }else if(worth == DDSpotShareWorthBad){
        [btnGood setImage:[UIImage imageNamed:@"ic_useful"] forState:UIControlStateNormal];
        [btnBad setImage:[UIImage imageNamed:@"ic_nouseful_hl"] forState:UIControlStateNormal];
    }
}

- (void)setHasFavor:(BOOL)hasFavor{
    _hasFavor = hasFavor;
    UIButton *btn = self.buttons[2];
    if(_hasFavor){
        [btn setImage:[UIImage imageNamed:@"ic_favor_hl"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"ic_favor"] forState:UIControlStateNormal];
    }
}

- (void)btnClick:(UIButton *)sender{
    if(sender.tag >=0 && sender.tag <= 1){
        if([self.delegate respondsToSelector:@selector(ddSpotShareCellFor:selecteWorth:)]){
            DDSpotShareWorth worth = sender.tag == 0 ? DDSpotShareWorthGood : DDSpotShareWorthBad;
            [self.delegate ddSpotShareCellFor:self.model selecteWorth:worth];
        }
    }else if(sender.tag == 2){
        if([self.delegate respondsToSelector:@selector(ddSpotShareCellFor:selecteFavor:)]){
            BOOL favor = !self.hasFavor;
            [self.delegate ddSpotShareCellFor:self.model selecteFavor:favor];
        }
    }
}

+ (CGFloat)heightForDetail:(NSString *)detail{
    return [detail boundingRectWithSize:CGSizeMake(kPreferredMaxLayoutWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont gs_font:NSAppFontM]} context:nil].size.height;
}

@end
