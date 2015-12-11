//
//  DDSpotWithShareListModel.h
//  diandi
//
//  Created by kjubo on 15/12/10.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotModel.h"
#import "DDShareInfoModel.h"
@interface DDSpotWithShareListModel : DDSpotModel
@property (nonatomic, strong) NSArray<DDShareInfoModel, Optional> *list;
@end
