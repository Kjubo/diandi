//
//  DDPopAreaView.h
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDArea.h"
@protocol DDPopAreaViewDelegate <NSObject>
@optional
- (void)ddPopAreaViewDidSelected:(DDArea *)data;
@end

@interface DDPopAreaView : UIView
@property (nonatomic, assign) id<DDPopAreaViewDelegate> delegate;
@end
