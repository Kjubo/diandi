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
    }
    return self;
}

@end
