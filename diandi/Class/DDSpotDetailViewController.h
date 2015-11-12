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
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, assign) DDSpotModel *spotModel;
@end
