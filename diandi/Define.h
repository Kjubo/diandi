//
//  Define.h
//  MyShoping
//
//  Created by boyu on 14-3-1.
//  Copyright (c) 2014年 boyu. All rights reserved.
//

#define kAppDebug YES

#ifdef kAppDebug
#define kAppHost @"http://120.25.225.177:9003/ddy"
#else
#define kAppHost @"http://120.25.225.177:9003/ddy"
#endif

#define kAppVersion     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppBundleId    [[NSBundle mainBundle] bundleIdentifier]
#define DF_WIDTH        [[UIScreen mainScreen] bounds].size.width

/**
 *  各种plugin的key
 */
#define GMAP_KEY                    @"" //百度地图key
#define UMENG_KEY                   @"" //友盟

#ifdef TEST_SERVER
#define GETUI_APPID                 @"veQnx4M7cW73f7Q82hVjH2"
#define GETUI_Key                   @"1Sn0vi6XgW5CWfhd3NR2tA"
#define GETUI_Secret                @"16vcAPeC6l8bVfyzEZZn44"
#else
#define GETUI_APPID                 @"DQour59LLM7IGfxJ1xXMz5"
#define GETUI_Key                   @"CR8KIxu9dE8IOkVDmDtf14"
#define GETUI_Secret                @"sa3qnhjP0w7BdRMf6V4lH7"
#endif


typedef NS_ENUM(NSInteger, NSAlertViewTag) {		/* UIAlertView 的类型 */
    NSAlertViewDefault = 1234,  /* 默认 */
    NSAlertViewOK,              /* 成功，提示，确认 */
    NSAlertViewError,           /* 错误 */
    NSAlertViewConfirm,         /* 确认 */
    NSAlertViewNeedLogin,       /* 需要登录 */
    NSAlertViewInput,
};

/**
 *  各种便捷方法和判断
 */
//屏幕逻辑大小
#define DF_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define DF_HEIGHT   [[UIScreen mainScreen] bounds].size.height
//判断系统
#define DEVICE_IPHONE6  (DF_WIDTH == 375.0)
#define DEVICE_IPHONE6P (DF_WIDTH >= 414.0)
//int to string
#define Int2String(iValue) [NSString stringWithFormat:@"%@", @(iValue)]

//十六进制颜色转换（0xFFFFFF）
#define HEXRGBCOLOR(hex)  [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
//默认颜色
#define GS_COLOR_MAIN           HEXRGBCOLOR(0x222222)
#define GS_COLOR_RED            HEXRGBCOLOR(0xff5400)
#define GS_COLOR_BACKGROUND     HEXRGBCOLOR(0xf0f0f0)
#define GS_COLOR_ORANGE         [UIColor orangeColor]
#define GS_COLOR_GREEN          HEXRGBCOLOR(0x7aab67)
#define GS_COLOR_BLUE           HEXRGBCOLOR(0x0077D5)
#define GS_COLOR_WHITE          HEXRGBCOLOR(0xFFFFFF)
#define GS_COLOR_LIGHT          HEXRGBCOLOR(0xE6E6E6)   //10%
#define GS_COLOR_LIGHTGRAY      HEXRGBCOLOR(0xCCCCCC)   //10%
#define GS_COLOR_GRAY           HEXRGBCOLOR(0x999999)   //50%
#define GS_COLOR_DARKGRAY       HEXRGBCOLOR(0x666666)   //75%
#define GS_COLOR_BLACK          HEXRGBCOLOR(0x000000)


