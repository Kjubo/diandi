//
//  DDArea.h
//  diandi
//
//  Created by kjubo on 15/11/2.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@protocol DDArea
@end

@interface DDArea : JSONModel
@property (nonatomic, strong) NSString<Optional> *uuid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<DDArea, Optional> *list;
@end
