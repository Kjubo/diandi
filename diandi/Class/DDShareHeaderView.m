//
//  DDShareHeaderView.m
//  diandi
//
//  Created by kjubo on 15/11/18.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDShareHeaderView.h"

@interface DDShareHeaderView ()
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation DDShareHeaderView

- (instancetype)init{
    if(self = [super init]){
        self.lbTitle = [UILabel new];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.textColor = GS_COLOR_BLACK;
        self.lbTitle.font = [UIFont gs_font:NSAppFontL];
        [self addSubview:self.lbTitle];
        [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = GS_COLOR_LIGHT;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lbTitle.mas_bottom);
            make.left.right.equalTo(self.lbTitle);
            make.height.mas_equalTo(@1);
        }];
    }
    return self;
}

- (void)setShareCount:(NSInteger)count{
    self.lbTitle.text = [NSString stringWithFormat:@"经验分享(%@条)", @(count)];
}

@end
