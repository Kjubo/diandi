//
//  DDLoginViewController.h
//  diandi
//
//  Created by kjubo on 15/12/15.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "RootViewController.h"

@protocol DDLoginViewControllerDelegate <NSObject>

- (void)ddLoginViewControllerCancel;
- (void)ddLoginViewControllerVerify;

@end

@interface DDLoginViewController : RootViewController

@property (nonatomic, weak) id<DDLoginViewControllerDelegate> delegate;

@end
