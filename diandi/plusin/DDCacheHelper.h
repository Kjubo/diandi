//
//  UZCacheHelper.h
//  diandi
//
//  Created by kjubo on 15/11/5.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMddListModel.h"
@interface DDCacheHelper : NSObject

@property (nonatomic, strong) DDMddListModel *mddList;

+ (instancetype)shared;

@end

