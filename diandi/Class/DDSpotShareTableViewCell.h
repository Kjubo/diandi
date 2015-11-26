//
//  DDSpotShareTableViewCell.h
//  diandi
//
//  Created by kjubo on 15/11/18.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomShareInfoModel.h"

@protocol DDSpotShareTableViewCellDelegate <NSObject>

@optional
- (void)ddSpotShareCellFor:(DDShareInfoModel *)model selecteWorth:(DDSpotShareWorth)worth;
- (void)ddSpotShareCellFor:(DDShareInfoModel *)model selecteFavor:(BOOL)favor;
@end

@interface DDSpotShareTableViewCell : UITableViewCell
@property (nonatomic, assign) id<DDSpotShareTableViewCellDelegate> delegate;
@property (nonatomic, strong) DDShareInfoModel *model;
@property (nonatomic) BOOL goodCount;
@property (nonatomic) BOOL badCount;
@property (nonatomic) BOOL favorCount;

@property (nonatomic) DDSpotShareWorth worth;
@property (nonatomic) BOOL hasFavor;


+ (CGFloat)heightForDetail:(NSString *)detail;
@end