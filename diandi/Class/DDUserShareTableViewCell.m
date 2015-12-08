//
//  DDUserShareTableViewCell.m
//  diandi
//
//  Created by kjubo on 15/12/7.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDUserShareTableViewCell.h"

@interface DDUserShareTableViewCell ()
@property (nonatomic, strong) UIImageView *ivType;
@property (nonatomic, strong) UILabel *lbDetail;
@end

#define kPreferredMaxLayoutWidth (DF_WIDTH - 30.0)
@implementation DDUserShareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UIView *line = [UIView new];
        line.backgroundColor = GS_COLOR_LIGHTGRAY;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@1);
        }];
        
        self.ivType = [UIImageView new];
        self.ivType.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.ivType];
        [self.ivType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.top.equalTo(self.contentView).offset(15);
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
            make.top.equalTo(self.ivType);
            make.left.equalTo(self.ivType.mas_right).offset(6);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)setDataModel:(DDShareInfoModel *)model{
    self.ivType.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_share_%@", kShareTypeIconNames[model.shareType]]];
    self.lbDetail.text = [model.content copy];
}

+ (CGFloat)heightForDetail:(NSString *)detail{
    return MAX (44, [detail boundingRectWithSize:CGSizeMake(kPreferredMaxLayoutWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont gs_font:NSAppFontM]} context:nil].size.height);
}

@end
