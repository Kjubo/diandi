//
//  ASWaitingView.h
//  astro
//
//  Created by kjubo on 14-1-28.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefalutLoadingText @"加载中.."

@interface ASWaitingView : UIView

@property (nonatomic, assign) UIViewController *viewController;

- (id)initWithBaseViewController:(UIViewController *)vc;
- (void)showWating:(NSString *)tips;
- (void)hideWaiting;
@end
