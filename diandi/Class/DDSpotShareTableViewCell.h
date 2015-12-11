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
- (void)ddSpotShareCellFor:(id<DDShareInfoModel>)model selecteWorth:(DDSpotShareWorth)worth;
- (void)ddSpotShareCellFor:(id<DDShareInfoModel>)model selecteFavor:(BOOL)favor;
@end

@interface DDSpotShareTableViewCell : UITableViewCell
@property (nonatomic, assign) id<DDSpotShareTableViewCellDelegate> delegate;
@property (nonatomic, strong) id<DDShareInfoModel> model;
@property (nonatomic) NSInteger goodCount;
@property (nonatomic) NSInteger badCount;
@property (nonatomic) NSInteger favorCount;

@property (nonatomic) DDSpotShareWorth worth;
@property (nonatomic) BOOL hasFavor;


+ (CGFloat)heightForDetail:(NSString *)detail;
@end
