//
//  DDSpotModel.h
//  diandi
//
//  Created by kjubo on 15/9/26.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@interface DDSpotModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *uuid;
@property (nonatomic, strong) NSString<Optional> *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString<Optional> *subtitle;
@property (nonatomic) NSInteger poitype;
@property (nonatomic) NSInteger favor;
@property (nonatomic) NSInteger hot;
@end
