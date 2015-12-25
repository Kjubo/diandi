//
//  DDUserModel.h
//  diandi
//
//  Created by kjubo on 15/12/21.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"

typedef NS_ENUM(NSInteger, DDOauthType) {
    DDOauthTypeWeixin = 1,
    DDOauthTypeSina = 2,
    DDOauthTypeQQ = 3,
};

@interface DDUserModel : JSONModel

@end
