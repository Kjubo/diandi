//
//  NSArray+JSONModelAddtion.m
//  diandi
//
//  Created by kjubo on 15/11/20.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "NSArray+JSONModelAddtion.h"

@implementation NSArray (JSONModelAddtion)

- (NSString*)toJSONString {
    NSMutableArray* jsonObjects = [NSMutableArray new];
    for ( id obj in self ){
        if([obj isKindOfClass:[JSONModel class]]){
            [jsonObjects addObject:[obj toJSONString]];
        }else if([obj isKindOfClass:[NSDictionary class]]){
            NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
            [jsonObjects addObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        }
    }
    return [NSString stringWithFormat:@"[%@]", [jsonObjects componentsJoinedByString:@","]];
}


@end
