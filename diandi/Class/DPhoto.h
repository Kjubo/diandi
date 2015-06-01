//
//  DPhoto.h
//  diandi
//
//  Created by kjubo on 15/6/1.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSign;

@interface DPhoto : NSManagedObject

@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) DSign *sign;

@end
