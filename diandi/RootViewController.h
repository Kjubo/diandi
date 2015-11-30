//
//  RootViewController.h
//  MyShoping
//
//  Created by boyu on 14-3-1.
//  Copyright (c) 2014年 boyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

- (void)loadingShow;
- (void)loadingShow:(NSString *)message;
- (void)loadingHidden;

+ (void)callPhone:(NSString *)phoneNumber;
+ (void)showAlert:(NSString *)message;
@end
