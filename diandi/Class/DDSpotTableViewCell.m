//
//  DDSpotTableViewCell.m
//  diandi
//
//  Created by kjubo on 15/11/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotTableViewCell.h"
#import "DDSpotSummaryView.h"

@interface DDSpotTableViewCell ()
@property (nonatomic, strong) DDSpotSummaryView *summaryView;
@end

@implementation DDSpotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.summaryView = [DDSpotSummaryView new];
        [self.contentView addSubview:self.summaryView];
        [self.summaryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = GS_COLOR_LIGHT;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@1);
        }];
    }
    return self;
}

- (void)setDataModel:(DDSpotModel *)data{
    [self.summaryView setDataModel:data];
}
@end
