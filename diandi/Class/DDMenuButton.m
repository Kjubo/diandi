//
//  DDMenuButton.m
//  diandi
//
//  Created by kjubo on 15/8/25.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDMenuButton.h"

@interface DDMenuButton ()
@property (nonatomic, strong) UIImageView *ivIcon;
@end

@implementation DDMenuButton

- (instancetype)init{
    if(self = [super init]){
        self.ivIcon = [UIImageView new];
        self.ivIcon.backgroundColor = GS_COLOR_RED;
        self.titleLabel.font = [UIFont gs_font:NSAppFontL];
        [self setTitleColor:GS_COLOR_WHITE forState:UIControlStateNormal];
        [self setTitleColor:GS_COLOR_LIGHT forState:UIControlStateHighlighted];
        [self addSubview:self.ivIcon];
        [self.ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 12));
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(2);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    [self setTitle:[title copy] forState:UIControlStateNormal];
}

- (NSString *)title{
    return self.titleLabel.text;
}

@end
