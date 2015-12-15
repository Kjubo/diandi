//
//  DDSpotDetailModel.h
//  diandi
//
//  Created by kjubo on 15/11/24.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "DDSpotModel.h"

@interface DDSpotDetailModel : JSONModel<DDSpotModel>
@property (nonatomic, strong) NSString<Optional> *uuid;
@property (nonatomic, strong) NSString<Optional> *img;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString<Optional> *subtitle;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *address;
@property (nonatomic, strong) NSString<Optional> *open;
@property (nonatomic, strong) NSString<Optional> *tel;
@property (nonatomic) NSInteger favor;
@property (nonatomic) NSInteger hot;
@property (nonatomic) NSNumber<Optional> *plnum;
@property (nonatomic) BOOL favored;
@end
