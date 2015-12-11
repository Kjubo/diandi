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

@end

@implementation DDUserSpotShareHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.summaryView = [DDSpotSummaryView new];
        [self addSubview:self.summaryView];
        [self.summaryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setDataModel:(DDSpotModel *)data{
    [self.summaryView setDataModel:data];
}

@end
