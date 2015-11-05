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
@synthesize mddList = _mddList;

+ (instancetype)shared{
    static DDCacheHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DDCacheHelper alloc] init];
    });
    return instance;
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

- (void)setMddList:(DDMddListModel *)mddList{
    _mddList = mddList;
    if(_mddList){
        [[ASCache shared] storeValue:[_mddList toJSONString] dir:kCacheDirForData key:kCacheKeyForMdd];
    }else{
        [[ASCache shared] removeDir:kCacheDirForData key:kCacheKeyForMdd];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_MddList_Update object:nil];
}

@end
