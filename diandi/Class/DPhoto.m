//
//  DPhoto.m
//  diandi
//
//  Created by kjubo on 15/6/1.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DPhoto.h"
#import "DSign.h"


@implementation DPhoto

@dynamic createTime;
@dynamic latitude;
@dynamic longitude;
@dynamic uri;
@dynamic uuid;
@dynamic sign;

+ (instancetype)newPhoto{
    DPhoto *ph = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DPhoto class]) inManagedObjectContext:[RootViewController managedObjectContext]];
    return ph;
}

- (CLLocation *)location{
    if(self.latitude && self.longitude){
        return [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    }
    return nil;
}

@end
