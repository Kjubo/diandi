//
//  UIFont+Addtion.h
//  zhihui
//
//  Created by kjubo on 15/7/1.
//  Copyright (c) 2015年 吉运软件. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NSAppFontSize){
    NSAppFontXXS = 0,
    NSAppFontXS,
    NSAppFontS,
    NSAppFontM,
    NSAppFontL,
    NSAppFontXL,
    NSAppFontXXL
};

@interface UIFont (Addtion)
+ (UIFont *)gs_font:(NSAppFontSize)fontSize;
+ (UIFont *)gs_boldfont:(NSAppFontSize)fontSize;
@end
