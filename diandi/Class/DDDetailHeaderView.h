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
- (void)ddDetailHeaderViewDidSelectedFavorite;  //收藏
- (void)ddDetailHeaderViewDidOpenMap;           //地图
- (void)ddDetailHeaderViewDidCall;              //打电话
- (void)ddDetailHeaderViewDidOpenDesc;          //打开介绍详情
@end

@interface DDDetailHeaderView : UIView

@property (nonatomic, assign) id<DDDetailHeaderViewDelegate> delegate;

@property (nonatomic) BOOL isFavorite;
@property (nonatomic, weak) DDSpotDetailModel *model;
@end
