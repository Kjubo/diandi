//
//  DAnnotation.h
//  diandi
//
//  Created by kjubo on 15/5/19.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAnnotation : NSObject <MKAnnotation>

//显示标注的经纬度
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
//标注的标题
@property (nonatomic,copy,readonly) NSString * title;
//标注的子标题
@property (nonatomic,copy,readonly) NSString * subtitle;

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)title subTitle:(NSString *)subTitle;

@end
