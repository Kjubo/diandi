//
//  DGroup.h
//  
//
//  Created by kjubo on 15/7/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DGroup : NSManagedObject

@property (nonatomic, retain) NSString * context;
@property (nonatomic, retain) NSData * converImage;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * timeEnd;
@property (nonatomic, retain) NSDate * timeStart;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * uuid;

@end
