//
//  AppDelegate.m
//  diandi
//
//  Created by kjubo on 15/4/16.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "AppDelegate.h"
#import "DDTabBarViewController.h"
#import "MobClick.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:nil];
    [MobClick setEncryptEnabled:YES];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName : GS_COLOR_WHITE,
                                                            NSFontAttributeName : [UIFont gs_font:NSAppFontXL]}];
    [[UINavigationBar appearance] setBarTintColor:GS_COLOR_MAIN];
    [[UINavigationBar appearance] setTintColor:GS_COLOR_WHITE];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:GS_COLOR_MAIN size:CGSizeMake(1, 45)]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont gs_boldfont:NSAppFontXS],
                                                        NSForegroundColorAttributeName : GS_COLOR_GRAY}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont gs_boldfont:NSAppFontXS],
                                                        NSForegroundColorAttributeName : HEXRGBCOLOR(0x00A6FF)}
                                             forState:UIControlStateSelected];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName : GS_COLOR_WHITE, NSFontAttributeName : [UIFont gs_font:NSAppFontL]} forState:UIControlStateNormal];
    
    //初始化window
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    DDTabBarViewController *vc = [[DDTabBarViewController alloc] init];
    //配置页面到导航vc
    self.nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.nav setNavigationBarHidden:YES];
    //设置rootViewController
    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

@end
