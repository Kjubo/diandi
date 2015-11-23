//
//  DDCustomShareInfoModel.h
//  diandi
//
//  Created by kjubo on 15/11/20.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "DDShareInfoModel.h"

typedef NS_ENUM(NSInteger, DDSpotShareWorth){
    DDSpotShareWorthNone = 0,
    DDSpotShareWorthGood = 1,
    DDSpotShareWorthBad  = 2,
};

@interface DDCustomShareInfoModel : JSONModel
@property (nonatomic, strong) DDShareInfoModel *shareInfo;
@property (nonatomic) DDSpotShareWorth worth;
@property (nonatomic) BOOL hasFavor;
@end
