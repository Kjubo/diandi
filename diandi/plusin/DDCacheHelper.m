//
//  UZCacheHelper.m
//  diandi
//
//  Created by kjubo on 15/11/5.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDCacheHelper.h"
#import "ASCache.h"

static NSString *kCacheDirForData   = @"kCacheDataDir";
static NSString *kCacheKeyForMdd    = @"kCacheKeyForMdd";
@implementation DDCacheHelper

+ (instancetype)shared{
    static DDCacheHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DDCacheHelper alloc] init];
    });
    return instance;
}

- (void)save{
    if(self.mddList){
        [[ASCache shared] storeValue:[self.mddList toJSONString] dir:kCacheDirForData key:kCacheKeyForMdd];
    }else{
        [[ASCache shared] removeDir:kCacheDirForData key:kCacheKeyForMdd];
    }
}

- (DDMddListModel *)mddList{
    if(!_mddList){
        ASCacheObject *co = [[ASCache shared] readDicFiledsWithDir:kCacheDirForData key:kCacheKeyForMdd];
        if(co && co.isVaild){
            _mddList = [[DDMddListModel alloc] initWithString:co.value error:nil];
        }
    }
    return _mddList;
}

@end
