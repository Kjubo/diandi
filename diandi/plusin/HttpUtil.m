/**
 * http工具类
 * @author qianjiefeng
 *
 */

#import "HttpUtil.h"
#import "Cipher.h"
#import "UIDevice+Addition.h"
#import "AppDelegate.h"
NSString *const kAppAgent = @"app-agent";
NSString *const kAppVerify = @"Restecname";
NSString *const kAppToken= @"ytoken";
NSString *const kAppDeviceSize = @"app-device-size";


static NSString *kUSER_UUID = @"123456789";
@implementation HttpUtil

+ (void)load:(NSString *)url params:(NSDictionary *)params completion:(HttpUtilBlock)completeBlock{
    [self http:url method:emHttpGet params:params orBodyString:nil timeOut:0 completion:completeBlock];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params completion:(HttpUtilBlock)completeBlock{
    [self post:url params:params bodyData:nil completion:completeBlock];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params bodyData:(NSData *)body completion:(HttpUtilBlock)completeBlock{
    NSMutableString *paramsString = [NSMutableString stringWithString:@""];
    if (params && body) {
        //build a simple url encoded param string
        for (NSString* key in [[params allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
            [paramsString appendFormat:@"%@=%@&", key, [self urlEncode:params[key]] ];
        }
        if ([paramsString hasSuffix:@"&"]) {
            paramsString = [[NSMutableString alloc] initWithString: [paramsString substringToIndex: paramsString.length-1]];
        }
    }
    if([paramsString length] > 0){
        url = [NSString stringWithFormat:@"%@?%@", url, paramsString];
        [self http:url method:emHttpPost params:nil orBodyData:body timeOut:0 completion:completeBlock];
    }else{
        [self http:url method:emHttpPost params:params orBodyData:body timeOut:0 completion:completeBlock];
    }
}

+ (void)http:(NSString *)url
      method:(emHttpMethod)method
      params:(NSDictionary *)params
orBodyString:(NSString *)body
     timeOut:(int)sec
  completion:(HttpUtilBlock)completeBlock
{
    [self http:url method:method params:params orBodyData:[body dataUsingEncoding:NSUTF8StringEncoding] timeOut:sec completion:completeBlock];
}

+ (void)http:(NSString *)url
      method:(emHttpMethod)method
      params:(NSDictionary *)params
  orBodyData:(NSData *)body
     timeOut:(int)sec
  completion:(HttpUtilBlock)completeBlock
{
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@", kAppHost, url];
    //超时时间
    if (sec <= 0) {
        [JSONHTTPClient setTimeoutInSeconds:10.0];
    }
    [JSONHTTPClient setTimeoutInSeconds:sec];
  
    //头部参数
    NSMutableDictionary* headers = [JSONHTTPClient requestHeaders];
    headers[kAppAgent] = [self appAgentStr];
//    headers[kAppVerify] = [self restEcName];
    headers[kAppDeviceSize] = [NSString stringWithFormat:@"%.0f_%.0f", DF_WIDTH, DF_HEIGHT];
    headers[kAppToken] = kUSER_UUID;
    
    //token
    //[req addRequestHeader:kHttpTokenForHeader value:Global.instance.userInfo.token];
    //设置data
    if (method == emHttpPost) {
        if(params && [params count] > 0){
            [JSONHTTPClient JSONFromURLWithString:completeUrl method:@"POST" params:params orBodyString:nil headers:headers completion:^(id json, JSONModelError *err) {
                [self completionBlock:json error:err completion:completeBlock];
            }];
        }else{
            [JSONHTTPClient JSONFromURLWithString:completeUrl method:@"POST" params:nil orBodyData:body headers:headers completion:^(id json, JSONModelError *err) {
                [self completionBlock:json error:err completion:completeBlock];
            }];
        }
    }else{
        [JSONHTTPClient JSONFromURLWithString:completeUrl method:@"GET" params:params orBodyString:nil headers:headers completion:^(id json, JSONModelError *err) {
            [self completionBlock:json error:err completion:completeBlock];
        }];
    }
     
}

+ (void)completionBlock:(id)json error:(JSONModelError *)err completion:(HttpUtilBlock)completeBlock{
    BOOL succ = NO;
    NSString *message = nil;
    id jsonObject = nil;
    if(err != NULL || json == nil){
        message = @"网络不给力哦!";
    }else if([json[@"code"] intValue] != 200){
        message = json[@"message"];
    }else{
        succ = YES;
        message = json[@"message"];
        jsonObject = json[@"value"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completeBlock) {
            completeBlock(succ, message, jsonObject);
        }
    });
}

+(NSString*)urlEncode:(id<NSObject>)value
{
    //make sure param is a string
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [(NSNumber*)value stringValue];
    }
    
    NSAssert([value isKindOfClass:[NSString class]], @"request parameters can be only of NSString or NSNumber classes. '%@' is of class %@.", value, [value class]);
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef) value,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

+ (NSString *)appAgentStr{
    NSString *re = [NSString stringWithFormat:@"%@/%@(Platform=%@/%@; MobileDevice=Apple/%@; MobileDeviceId=%@; DeviceSize=%.0f/%.0f;)",
                    [[NSBundle mainBundle] bundleIdentifier], kAppVersion,
                    [UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion,
                    [UIDevice currentDevice].model,
                    [[UIDevice currentDevice] uniqueDeviceGuid],
                    DF_WIDTH * 2, DF_HEIGHT * 2
                    ];
    return re;
}

+ (NSString *)restEcName{
    //将 设备号+时间戳 放入请求头
    NSMutableString *ecName = [NSMutableString string];
    [ecName appendFormat:@"%@_%@", [[UIDevice currentDevice] uniqueDeviceGuid], [[UIDevice currentDevice] keyChainDeviceGuid]];
    [ecName appendString:@","];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 100; //10毫秒级别
    [ecName appendString:[NSString stringWithFormat:@"%.0f",time]];
    NSData* plainData = [ecName dataUsingEncoding: NSUTF8StringEncoding];
    NSData* encryptedData = [[Cipher shared] encrypt:plainData];
    NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@" <>"];
    NSString *hexRepresentation = [[encryptedData description] stringByTrimmingCharactersInSet:charsToRemove] ;
    hexRepresentation = [hexRepresentation stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [hexRepresentation uppercaseString];
}

@end



