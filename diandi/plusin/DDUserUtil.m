//
//  DDUserUtil.m
//  diandi
//
//  Created by kjubo on 15/12/21.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDUserUtil.h"
#import "ASCache.h"

@implementation DDUserUtil

+(instancetype)shared{
    static DDUserUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DDUserUtil alloc] init];
    });
    return instance;
}

//-(id)init
//{
//    self = [super init];
//    if (self) {
//        ASCacheObject *co = [[ASCache shared] readDicFiledsWithDir:kCacheDirForUser key:kCacheKeyLoginUser];
//        if([co isVaild]){
//            NSError *error;
//            self.login = [[UZLoginResult alloc] initWithString:co.value error:&error];
//        }
//    }
//    return self;
//}

#pragma mark - 用户信息
//- (void)setLogin:(UZLoginResult *)login{
//    if(login && [login.token length] > 0){
//        _login = login;
//        [self updateCache];
//    }
//}

//- (void)updateCache{
//    [[ASCache shared] storeValue:[_login toJSONString] dir:kCacheDirForUser key:kCacheKeyLoginUser];
//}

//取登录用户uid
//- (NSString *)userToken{
//    if([self hasLogined]){
//        return [self.login.token copy];
//    }
//    return @"";
//}

//判断用户是否登录 yes登录 no未登录
//- (BOOL)hasLogined
//{
//    if (self.login && [self.login.token length] > 0) {
//        return YES;
//    }
//    return NO;
//}

//注销删除本地用户信息
//- (void)loginOut
//{
//    _login = nil;
//    [[ASCache shared] removeDir:kCacheDirForUser];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_LoginOut object:nil];
//}

#pragma mark -
//+ (void)handleOpenURL:(NSString *)urlString title:(NSString *)title type:(NSInteger)type needLogin:(BOOL)needLogin{
//    AppDelegate *currentDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
//    
//    UINavigationController *nc = currentDelegate.nav;
//    NSString *strUrl = [urlString stringByReplacingOccurrencesOfString:@"http://page.chinaezlink.com/info/" withString:@"cyc://"];
//    NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    if([@"http" isEqualToString:[url scheme]]){
//        if(type == 2){ //应用外wap
//            [[UIApplication sharedApplication] openURL:url];
//        }else{//应用内wap
//            ASWebViewController *webVc = [[ASWebViewController alloc] init];
//            webVc.title = [title copy];
//            webVc.redirect_uri = [urlString copy];
//            [nc pushViewController:webVc animated:YES];
//        }
//    }else if([@"cyc" isEqualToString:[url scheme]]){                  //内页
//        //解析host  example : gosheng://goods/1212
//        //        NSString *host = url.host;//restdetail
//        //        NSArray *argv = [[url absoluteString] componentsSeparatedByString:@"/"];
//        //        if ([@"goods" isEqualToString:host]
//        //            && [argv count] > 3) {
//        //            CommodityInfoVC *infoVC = [[CommodityInfoVC alloc] init];
//        //            infoVC.goodsNo = [argv objectAtIndex:3];
//        //            infoVC.sid = @"0";
//        //            [nc pushViewController:infoVC animated:YES];
//        //        }
//    }else{
//        [BaseViewController showAlert:@"无效二维码"];
//    }
//}

@end
