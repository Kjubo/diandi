//
//  DDRankView.m
//  diandi
//
//  Created by kjubo on 15/11/11.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDRankView.h"

static CGFloat kViewHeight = 16.0;
@interface DDRankView ()
@end

@implementation DDRankView

- (instancetype)init{
    if(self = [super init]){
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kViewHeight * 5, kViewHeight));
        }];
        for(int i = 0; i < 5; i++){
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_rank"]];
            iv.backgroundColor = [UIColor clearColor];
            [self addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(self.mas_height);
                make.top.equalTo(self);
                make.left.equalTo(self).offset(i * kViewHeight);
            }];
        }
        
        self.rank = 1;
    }
    return self;
}

- (void)setRank:(CGFloat)rank{
    _rank = rank;
    [self.maskView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_rank * kViewHeight);
    }];
}

@end
