//
//  DDShareInfoModel.h
//  diandi
//
//  Created by kjubo on 15/11/20.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"
typedef NS_ENUM(NSInteger, DDShareInfoType){
    DDShareInfoTypePhoto = 1,
    DDShareInfoTypeTraffic,
    DDShareInfoTypeSuitCase,
    DDShareInfoTypeNext,
    DDShareInfoTypeTalk,
};

#define kShareTypeIconNames @[@"photo", @"car", @"suitcase", @"next", @"talk"]
#define kShareTypeTitles    @[@"不能错过", @"交通工具", @"随行装备", @"去下一站", @"随便聊聊"]

@interface DDShareInfoModel : JSONModel

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *avaterImage;
@property (nonatomic, strong) NSString *postDate;
@property (nonatomic) DDShareInfoType shareType;
@property (nonatomic) NSInteger goodCount;
@property (nonatomic) NSInteger badCount;
@property (nonatomic) NSInteger favorCount;
@property (nonatomic, strong) NSString *content;

@end
