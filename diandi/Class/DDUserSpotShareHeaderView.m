//
//  DDUserSpotShareHeaderView.m
//  diandi
//
//  Created by kjubo on 15/12/10.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDUserSpotShareHeaderView.h"
#import "DDSpotSummaryView.h"

@interface DDUserSpotShareHeaderView ()
@property (nonatomic, strong) DDSpotSummaryView *summaryView;
@property (nonatomic, strong) UIImageView *arrowLine;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation DDUserSpotShareHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = GS_COLOR_WHITE;
        
        self.summaryView = [DDSpotSummaryView new];
        [self.contentView addSubview:self.summaryView];
        [self.summaryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        self.bottomLine = [UIView new];
        self.bottomLine.backgroundColor = GS_COLOR_LIGHT;
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@1);
        }];
        
        self.arrowLine = [UIImageView new];
        self.arrowLine.image = [UIImage imageNamed:@"ic_arrow_bg"];
        self.arrowLine.hidden = YES;
        [self.contentView addSubview:self.arrowLine];
        [self.arrowLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(@6);
        }];
    }
    return self;
}

- (void)setDataModel:(DDSpotModel *)data showArrowLine:(BOOL)showTag{
    _spotModel = [data copy];
    [self.summaryView setDataModel:data];
    self.arrowLine.hidden = !showTag;
    self.bottomLine.hidden = showTag;
}

@end
