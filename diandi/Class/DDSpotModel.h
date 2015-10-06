//
//  DDSpotModel.h
//  diandi
//
//  Created by kjubo on 15/9/26.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@interface DDSpotModel : JSONModel

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *converImageUri;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userFaceUri;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *dateSpan;
@property (nonatomic, strong) NSString *personCount;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic) NSInteger keepCount;

@end
