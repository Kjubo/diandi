//
//  DDSpotDetailViewController.h
//  diandi
//
//  Created by kjubo on 15/11/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "RootViewController.h"
#import "DDSpotModel.h"

@interface DDSpotDetailViewController : RootViewController
@property (nonatomic, strong) DDSpotModel *spotInfo;

+ (instancetype)newSpotDetailViewController:(DDSpotModel *)spotInfo;
@end
