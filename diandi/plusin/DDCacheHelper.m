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
@property (nonatomic, strong) NSMutableArray *lstSpotHistory;
@end

static NSString *kCacheDirForData               = @"kCacheDataDir";
static NSString *kCacheKeyForMdd                = @"kCacheKeyForMdd";
static NSString *kCacheKeyForSearchHistoryList  = @"kCacheKeyForSearchHistoryList";
static NSString *kCacheKeyForSpotHistoryList    = @"kCacheKeyForSpotHistoryList";

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
            if(obj != nil && [obj isKindOfClass:[NSArray class]]){
                [self.lstSearchHistory addObjectsFromArray:obj];
            }
        }
        self.lstSpotHistory = [NSMutableArray array];
        co = [[ASCache shared] readDicFiledsWithDir:kCacheDirForData key:kCacheKeyForSpotHistoryList];
        if(co && co.isVaild){
            id obj = [DDSpotModel arrayOfModelsFromData:[co.value dataUsingEncoding:NSUTF8StringEncoding] error:nil];
            if(obj != nil && [obj isKindOfClass:[NSArray class]]){
                [self.lstSpotHistory addObjectsFromArray:obj];
            }
        }
    }
    return self;
}

- (NSArray *)searchHistoryList{
    return self.lstSearchHistory;
}

- (NSArray<DDSpotModel> *)viewHistoryList{
    return (NSArray<DDSpotModel> *)self.lstSpotHistory;
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

- (void)addViewHistory:(id<DDSpotModel>)spot{
    if(!spot) return;
    
    __block BOOL hasContain = NO;
    [self.lstSpotHistory enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<DDSpotModel> item = obj;
        if([item.uuid isEqualToString:spot.uuid]){
            hasContain = YES;
            *stop = YES;
        }
    }];
    if(!hasContain){
        [self.lstSpotHistory insertObject:spot atIndex:0];
        if([self.lstSpotHistory count] > 30){
            [self.lstSpotHistory removeLastObject];
        }
        [[ASCache shared] storeValue:[self.lstSpotHistory toJSONString] dir:kCacheDirForData key:kCacheKeyForSpotHistoryList];
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
