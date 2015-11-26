//
//  DDDetailHeaderView.h
//  diandi
//
//  Created by kjubo on 15/11/18.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSpotDetailModel.h"

@protocol DDDetailHeaderViewDelegate <NSObject>

@optional
- (void)ddDetailHeaderViewDidSelectedFavorite;

@end

@interface DDDetailHeaderView : UIView

@property (nonatomic, assign) id<DDDetailHeaderViewDelegate> delegate;

@property (nonatomic) BOOL isFavorite;
- (void)setSpotModel:(DDSpotDetailModel *)model;

@end
