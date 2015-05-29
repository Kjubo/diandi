//
//  PopAnnotationView.h
//  diandi
//
//  Created by kjubo on 15/5/28.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PopAnnotationView : MKAnnotationView
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) NSString *photoURL;
@end
