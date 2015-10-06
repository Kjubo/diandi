//
//  DDPopContainerView.h
//  diandi
//
//  Created by kjubo on 15/10/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPopContainerView : UIView

@property (nonatomic, assign) id<UITableViewDelegate> tableViewDelegate;
@property (nonatomic, assign) id<UITableViewDataSource> tableViewDataSource;

@end
