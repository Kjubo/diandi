//
//  DAnnotation.h
//  diandi
//
//  Created by kjubo on 15/5/19.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAnnotation : NSObject <MKAnnotation>

@property(nonatomic) CLLocationCoordinate2D coordinate;

@end
