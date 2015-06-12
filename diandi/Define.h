//
//  Define.h
//  MyShoping
//
//  Created by boyu on 14-3-1.
//  Copyright (c) 2014年 boyu. All rights reserved.
//

#define kAppDebug YES
#define kAppVersion     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppBundleId    [[NSBundle mainBundle] bundleIdentifier]
#define kPlaceholderImageName @"location_blue"
#define kMaxAnnotationCount 50

typedef NS_ENUM(NSInteger, NSAlertViewTag) {		/* UIAlertView 的类型 */
    NSAlertViewDefault = 1234,  /* 默认 */
    NSAlertViewOK,              /* 成功，提示，确认 */
    NSAlertViewError,           /* 错误 */
    NSAlertViewConfirm,         /* 确认 */
    NSAlertViewNeedLogin,       /* 需要登录 */
    NSAlertViewInput,
};
//判断系统
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)


