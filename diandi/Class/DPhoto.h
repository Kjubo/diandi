//
//  DPhoto.h
//  
//
//  Created by kjubo on 15/7/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DPhoto : NSManagedObject

@property (nonatomic, retain) NSString * context;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * originalUri;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSData * thumbnailImage;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * uuid;

@end
