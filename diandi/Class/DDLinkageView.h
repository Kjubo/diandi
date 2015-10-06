//
//  DDLinkageView.h
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDLinkageView;
@protocol DDLinkageViewDelegate <NSObject>
@optional
- (void)ddLinkageView:(DDLinkageView *)linkageView didSelected:(NSIndexPath *)indexPath;

@end

@interface DDLinkageView : UIView

@property (nonatomic, assign) id<DDLinkageViewDelegate> delegate;
@property (nonatomic) NSInteger selectedStage1Index;

@end
