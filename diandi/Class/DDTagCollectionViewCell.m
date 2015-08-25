//
//  DDTagCollectionViewCell.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDTagCollectionViewCell.h"

@interface DDTagCollectionViewCell ()
@property (nonatomic, strong) UILabel *lbTitle;
@end

@implementation DDTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.lbTitle = [UILabel new];
        self.lbTitle.textAlignment = NSTextAlignmentCenter;
        self.lbTitle.textColor = GS_COLOR_WHITE;
        self.lbTitle.font = [UIFont gs_font:NSAppFontM];
        self.lbTitle.layer.cornerRadius = 6.0;
        self.lbTitle.clipsToBounds = YES;
        [self.contentView addSubview:self.lbTitle];
        [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    self.lbTitle.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor{
    return self.lbTitle.backgroundColor;
}

- (void)setText:(NSString *)text{
    self.lbTitle.text = [text copy];
}

- (NSString *)text{
    return self.lbTitle.text;
}

@end
