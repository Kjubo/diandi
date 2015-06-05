//
//  DSign.m
//  diandi
//
//  Created by kjubo on 15/6/1.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DSign.h"
#import "DPhoto.h"


@implementation DSign

@dynamic createTime;
@dynamic conver;
@dynamic latitude;
@dynamic longitude;
@dynamic uuid;
@dynamic photos;


+ (instancetype)newSign{
    DSign *sign = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DSign class]) inManagedObjectContext:[RootViewController managedObjectContext]];
    return sign;
}

- (CLLocation *)location{
    if(self.latitude && self.longitude){
        return [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    }
    return nil;
}

@end
