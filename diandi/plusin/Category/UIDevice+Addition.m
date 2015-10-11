//
//  UIDevice+Addition.m
//  Xms
//
//  Created by liuqiushi on 12-4-1.
//  Copyright (c) 2012年 订餐小秘书 . All rights reserved.
//

#import "UIDevice+Addition.h"
#import "NSString+Addition.h"
#import "ASCache.h"
#import "SSKeyChain.h"

@implementation UIDevice (Addition)

static NSString *kCacheDirForUuid = @"DeviceUniqueGlobalIdentifier";
- (NSString *)uniqueDeviceGuid{
    NSString *uuid = @"";
    ASCacheObject *cf = [[ASCache shared] readDicFiledsWithDir:kCacheDirForUuid key:kCacheDirForUuid];
    if(cf){
        uuid = [NSString stringWithString:cf.value];
    }else{
        uuid = [self generateGuid];
        [[ASCache shared] storeValue:uuid dir:kCacheDirForUuid key:kCacheDirForUuid];
    }
    return uuid;
}

- (NSString *)keyChainDeviceGuid{
    NSString *uuid = [SSKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier] account:@"user"];
    if([uuid length] == 0){
        uuid = [self uniqueDeviceGuid];
        [SSKeychain setPassword:uuid forService:[[NSBundle mainBundle] bundleIdentifier] account:@"user"];
    }
    return uuid;
}

- (NSString *)generateGuid{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
    
    CFRelease(uuidStringRef);
    CFRelease(uuidRef);
    return uuid;
}



@end
