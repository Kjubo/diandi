//
//  DDSearchEmptyView.h
//  diandi
//
//  Created by kjubo on 15/10/17.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDSearchEmptyViewDelegate <NSObject>

@optional
- (void)ddSearchEmptyViewDidSelect:(NSString *)searchKey;

@end

@interface DDSearchEmptyView : UIView

@property (nonatomic, assign) id<DDSearchEmptyViewDelegate> delegate;

@end
