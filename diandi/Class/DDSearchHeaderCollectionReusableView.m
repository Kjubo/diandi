//
//  DDSearchHeaderCollectionReusableView.m
//  diandi
//
//  Created by kjubo on 15/10/17.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSearchHeaderCollectionReusableView.h"

@interface DDSearchHeaderCollectionReusableView ()
@property (nonatomic, strong) UILabel *lbTitle;
@end

@implementation DDSearchHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.lbTitle = [UILabel new];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.textColor = GS_COLOR_WHITE;
        self.lbTitle.font = [UIFont gs_font:NSAppFontM];
        self.lbTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.lbTitle];
        [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    self.lbTitle.text = [title copy];
}

- (NSString *)title{
    return self.lbTitle.text;
}

@end
