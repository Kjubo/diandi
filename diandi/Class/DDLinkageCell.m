//
//  DDLinkageCell.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDLinkageCell.h"

@interface DDLinkageCell ()
@property (nonatomic, strong) UIView *line;
@end

@implementation DDLinkageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.textLabel.font = [UIFont gs_font:NSAppFontM];
        self.textLabel.textColor = GS_COLOR_BLACK;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont gs_font:NSAppFontL];
        self.backgroundColor = [UIColor clearColor];
        
        self.line = [UIView new];
        self.line.backgroundColor = GS_COLOR_LIGHT;
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(@1);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(selected){
        self.textLabel.textColor = GS_COLOR_MAIN;
        self.line.backgroundColor = GS_COLOR_MAIN;
    }else{
        self.textLabel.textColor = GS_COLOR_BLACK;
        self.line.backgroundColor = GS_COLOR_LIGHT;
    }
    [super setSelected:selected animated:animated];
}
@end
