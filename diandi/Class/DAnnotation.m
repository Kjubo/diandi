//
//  DAnnotation.m
//  diandi
//
//  Created by kjubo on 15/5/19.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DAnnotation.h"

@implementation DAnnotation

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)title subTitle:(NSString *)subTitle{
    if(self = [super init]){
        _coordinate = paramCoordinates;
        _title = [title copy];
        _subtitle = [subTitle copy];
    }
    return self;
}

@end
