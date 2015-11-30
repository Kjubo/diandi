//
//  DDShareHeaderView.m
//  diandi
//
//  Created by kjubo on 15/11/18.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDShareHeaderView.h"
#import "DDSpotShareTableViewCell.h"

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
        line.backgroundColor = GS_COLOR_GRAY;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lbTitle.mas_bottom).offset(4);
            make.left.right.equalTo(self.lbTitle);
            make.height.mas_equalTo(@1);
        }];
        
        for(int i = 0 ; i < [kShareTypeTitles count]; i++){
            CGSize itemSize = CGSizeMake(DF_WIDTH/[kShareTypeTitles count], 0);
            itemSize.height = itemSize.width + 20;
            
            UIView *itemView = [UIView new];
            [self addSubview:itemView];
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(itemSize);
                make.left.equalTo(@(itemSize.width * i));
                make.top.equalTo(line.mas_bottom);
            }];
            
            UIImageView *icon = [UIImageView new];
            icon.backgroundColor = [UIColor clearColor];
            [itemView addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(itemView).offset(14);
                make.right.equalTo(itemView).offset(-14);
                make.height.equalTo(icon.mas_width);
            }];
            icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_share_%@", kShareTypeIconNames[i]]];
            
            UILabel *lbName = [UILabel new];
            lbName.text = kShareTypeTitles[i];
            lbName.textAlignment = NSTextAlignmentCenter;
            lbName.backgroundColor = [UIColor clearColor];
            lbName.textColor = GS_COLOR_BLACK;
            lbName.font = [UIFont gs_font:NSAppFontXS];
            [itemView addSubview:lbName];
            [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(icon.mas_bottom).offset(4);
                make.left.right.equalTo(itemView);
            }];
        }
    }
    return self;
}

- (void)setShareCount:(NSInteger)count{
    self.lbTitle.text = [NSString stringWithFormat:@"经验分享(%@条)", @(count)];
}

@end
