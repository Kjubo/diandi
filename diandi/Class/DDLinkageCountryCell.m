//
//  DDLinkageCountryCell.m
//  diandi
//
//  Created by kjubo on 15/12/14.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDLinkageCountryCell.h"

@implementation DDLinkageCountryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.textLabel.font = [UIFont gs_font:NSAppFontM];
        self.textLabel.textColor = GS_COLOR_BLACK;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont gs_font:NSAppFontL];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(selected){
        self.backgroundColor = GS_COLOR_WHITE;
        self.textLabel.textColor = GS_COLOR_MAIN;
    }else{
        self.backgroundColor = GS_COLOR_LIGHT;
        self.textLabel.textColor = GS_COLOR_BLACK;
    }
    [super setSelected:selected animated:animated];
}

@end
