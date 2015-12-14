//
//  UZCacheHelper.h
//  diandi
//
//  Created by kjubo on 15/11/5.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMddListModel.h"
#import "DDSpotModel.h"
@interface DDCacheHelper : NSObject

@property (nonatomic, strong) DDMddListModel *mddList;
@property (nonatomic, readonly) NSArray *searchHistoryList;
@property (nonatomic, readonly) NSArray<DDSpotModel> *viewHistoryList;
- (void)addSearchHistory:(NSString *)searchKey;
- (void)addViewHistory:(id<DDSpotModel>)spot;

+ (instancetype)shared;

@end

