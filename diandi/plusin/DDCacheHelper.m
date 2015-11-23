//
//  UZCacheHelper.m
//  diandi
//
//  Created by kjubo on 15/11/5.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDCacheHelper.h"
#import "ASCache.h"
#import "NSArray+JSONModelAddtion.h"
@interface DDCacheHelper ()
@property (nonatomic, strong) NSMutableArray *lstSearchHistory;
@end

static NSString *kCacheDirForData               = @"kCacheDataDir";
static NSString *kCacheKeyForMdd                = @"kCacheKeyForMdd";
static NSString *kCacheKeyForSearchHistoryList  = @"kCacheKeyForSearchHistoryList";
@implementation DDCacheHelper
@synthesize mddList = _mddList;
@synthesize searchHistoryList = _searchHistoryList;
+ (instancetype)shared{
    static DDCacheHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DDCacheHelper alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if(self = [super init]){
        self.lstSearchHistory = [NSMutableArray array];
        ASCacheObject *co = [[ASCache shared] readDicFiledsWithDir:kCacheDirForData key:kCacheKeyForSearchHistoryList];
        if(co && co.isVaild){
            id obj = [NSJSONSerialization JSONObjectWithData:[co.value dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            if([obj isKindOfClass:[NSArray class]]){
                [self.lstSearchHistory addObjectsFromArray:obj];
            }
        }
    }
    return self;
}

- (NSArray *)searchHistoryList{
    return self.lstSearchHistory;
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

- (void)addSearchHistory:(NSString *)searchKey{
    if([searchKey length] == 0) return;
    
    __block BOOL hasContain = NO;
    [self.lstSearchHistory enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:searchKey]){
            hasContain = YES;
            *stop = YES;
        }
    }];
    if(!hasContain){
        [self.lstSearchHistory insertObject:searchKey atIndex:0];
        [[ASCache shared] storeValue:[self.lstSearchHistory toJSONString] dir:kCacheDirForData key:kCacheKeyForSearchHistoryList];
    }
    
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
