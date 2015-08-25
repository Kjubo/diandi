//
//  UIFont+Addtion.m
//  zhihui
//
//  Created by kjubo on 15/7/1.
//  Copyright (c) 2015年 吉运软件. All rights reserved.
//

#import "UIFont+Addtion.h"

#define kAppBaseFonts @{ \
@(NSAppFontXXS) : @(9), \
@(NSAppFontXS)  : @(11), \
@(NSAppFontS)   : @(12), \
@(NSAppFontM)   : @(13), \
@(NSAppFontL)   : @(14), \
@(NSAppFontXL)  : @(18), \
@(NSAppFontXXL) : @(20), \
}

@implementation UIFont (Addtion)

+ (UIFont *)gs_font:(NSAppFontSize)fontSize{
    if(DEVICE_IPHONE6){
        return [UIFont systemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue] * 1.1];
    }else if(DEVICE_IPHONE6P){
        return [UIFont systemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue] * 1.2];
    }else{
        return [UIFont systemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue]];
    }
}

+ (UIFont *)gs_boldfont:(NSAppFontSize)fontSize{
    if(DEVICE_IPHONE6){
        return [UIFont boldSystemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue] * 1.1];
    }else if(DEVICE_IPHONE6P){
        return [UIFont boldSystemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue] * 1.2];
    }else{
        return [UIFont boldSystemFontOfSize:[kAppBaseFonts[@(fontSize)] floatValue]];
    }
}

@end
