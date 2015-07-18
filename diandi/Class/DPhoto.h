//
//  DPhoto.h
//  
//
//  Created by kjubo on 15/7/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DGroup;

@interface DPhoto : NSManagedObject

@property (nonatomic, retain) NSString * context;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) DGroup *group;

@end
