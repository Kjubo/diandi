//
//  DPhoto.h
//  
//
//  Created by kjubo on 15/7/10.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DPhoto : NSManagedObject

@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * originalUri;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSData * thumbnailImage;

@end
