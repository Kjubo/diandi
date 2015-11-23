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

@interface DDShareInfoModel : JSONModel

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *avaterName;
@property (nonatomic, strong) NSString *avaterImage;
@property (nonatomic, strong) NSString *postDate;
@property (nonatomic) DDShareInfoType shareType;
@property (nonatomic) NSInteger goodCount;
@property (nonatomic) NSInteger badCount;
@property (nonatomic) NSInteger favorCount;
@property (nonatomic, strong) NSString *content;

@end
