//
//  DGroup.h
//  
//
//  Created by kjubo on 15/7/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DPhoto;

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
@property (nonatomic, retain) NSOrderedSet *photos;
@end

@interface DGroup (CoreDataGeneratedAccessors)

- (void)insertObject:(DPhoto *)value inPhotosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPhotosAtIndex:(NSUInteger)idx;
- (void)insertPhotos:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePhotosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPhotosAtIndex:(NSUInteger)idx withObject:(DPhoto *)value;
- (void)replacePhotosAtIndexes:(NSIndexSet *)indexes withPhotos:(NSArray *)values;
- (void)addPhotosObject:(DPhoto *)value;
- (void)removePhotosObject:(DPhoto *)value;
- (void)addPhotos:(NSOrderedSet *)values;
- (void)removePhotos:(NSOrderedSet *)values;
@end
