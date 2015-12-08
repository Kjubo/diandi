//
//  DDTopMenuView.h
//  diandi
//
//  Created by kjubo on 15/10/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDTopMenuViewDelegate <NSObject>

@optional
- (void)ddTopMenuViewDidSelected:(NSInteger)tag;
- (void)ddTopMenuViewDidCancelSelected;
- (void)ddTopMenuViewDidSearch;

@end

@interface DDTopMenuView : UIView
@property (nonatomic, assign) id<DDTopMenuViewDelegate> delegate;
@end
