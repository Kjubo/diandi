//
//  DDSpotModel.h
//  diandi
//
//  Created by kjubo on 15/9/26.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@protocol DDSpotModel <NSObject>
@property (nonatomic, strong) NSString<Optional> *uuid;
@property (nonatomic, strong) NSString<Optional> *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString<Optional> *subtitle;
@property (nonatomic) NSInteger favor;
@property (nonatomic) NSInteger hot;

@optional
@property (nonatomic) NSNumber<Optional> *plnum;
@property (nonatomic, strong) NSString<Optional> *poiType;
@end

@interface DDSpotModel : JSONModel<DDSpotModel>
@property (nonatomic, strong) NSString<Optional> *uuid;
@property (nonatomic, strong) NSString<Optional> *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString<Optional> *subtitle;
@property (nonatomic) NSInteger favor;
@property (nonatomic) NSInteger hot;
@property (nonatomic) NSNumber<Optional> *plnum;
@property (nonatomic, strong) NSString<Optional> *poiType;
@end
