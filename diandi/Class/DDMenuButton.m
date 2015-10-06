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
        self.ivIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow_down"]];
        self.titleLabel.font = [UIFont gs_font:NSAppFontL];
        [self setTitleColor:GS_COLOR_WHITE forState:UIControlStateNormal];
        [self setTitleColor:GS_COLOR_BLUE forState:UIControlStateSelected];
        [self addSubview:self.ivIcon];
        [self.ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 9));
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(3);
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
