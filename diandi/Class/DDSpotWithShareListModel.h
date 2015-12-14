//
//  DDSpotWithShareListModel.h
//  diandi
//
//  Created by kjubo on 15/12/10.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotModel.h"
#import "DDCustomShareInfoModel.h"
@interface DDSpotWithShareListModel : DDSpotModel<DDSpotModel>
@property (nonatomic, strong) NSArray<DDCustomShareInfoModel, Optional> *pllist;
@end
