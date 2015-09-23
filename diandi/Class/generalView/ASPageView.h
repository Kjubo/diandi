//
//  ASPageView.h
//  gosheng3.0
//
//  Created by kjubo on 14/12/15.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASPageView;
@protocol ASPageViewDelegate <NSObject>

@optional
- (void)pageView:(ASPageView *)pageView didSelected:(NSInteger)index;

@end

@interface ASPageView : UIView<UIScrollViewDelegate>
@property (nonatomic, weak) id<ASPageViewDelegate> delegate;

- (void)setItems:(NSArray *)items andTimeInterval:(NSTimeInterval)interval;
@end
