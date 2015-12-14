//
//  DDLinkageCell.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDLinkageCell.h"

@implementation DDLinkageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.textLabel.font = [UIFont gs_font:NSAppFontM];
        self.textLabel.textColor = GS_COLOR_BLACK;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont gs_font:NSAppFontL];
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = GS_COLOR_BLACK;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(selected){
        self.backgroundColor = GS_COLOR_LIGHT;
        self.textLabel.textColor = GS_COLOR_MAIN;
    }else{
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = GS_COLOR_BLACK;
    }
    [super setSelected:selected animated:animated];
}
@end
