//
//  TourMainViewController.m
//  diandi
//
//  Created by kjubo on 15/4/16.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "TourMainViewController.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSDate+Addition.h"
#import "CLLocation+Addtion.h"
#import "DPhoto.h"
#import "DSign.h"

#define kMaxSignDistance 1000

@interface TourMainViewController () <ELCImagePickerControllerDelegate, MKMapViewDelegate>
@property (nonatomic, strong) ELCImagePickerController *imagePicker;
@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) NSMutableArray *signs;
@end

@implementation TourMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"照片+" style:UIBarButtonItemStyleDone target:self action:@selector(choosePhoto)];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
}

- (void)choosePhoto{
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - ELCImagePickerControllerDelegate
- (ELCImagePickerController *)imagePicker{
    if(!_imagePicker){
        _imagePicker = [[ELCImagePickerController alloc] initImagePicker];
        _imagePicker.imagePickerDelegate = self;
        _imagePicker.maximumImagesCount = 1000;
        _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    return _imagePicker;
}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    if([info count] <= 0) return;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create([kAppBundleId UTF8String], DISPATCH_QUEUE_SERIAL);
    
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                dispatch_async(queue, ^{
                    NSURL *imageURL = [dict objectForKey:UIImagePickerControllerReferenceURL];
                    ALAssetsLibrary *alib = [[ALAssetsLibrary alloc] init];
                    [alib assetForURL:imageURL resultBlock:^(ALAsset *asset) {
                        CLLocation *loc = [asset valueForProperty:ALAssetPropertyLocation];
                        NSDate *timestamp = [asset valueForProperty:ALAssetPropertyDate];
                        DPhoto *ph = [DPhoto newPhoto];
                        if(loc){
                            ph.latitude = @(loc.coordinate.latitude);
                            ph.longitude = @(loc.coordinate.longitude);
                        }
                        ph.createTime = timestamp;
                        ph.uri = imageURL.absoluteString;
                        ph.uuid = [[NSUUID UUID] UUIDString];
                        dispatch_semaphore_signal(sema);
                    } failureBlock:^(NSError *error) {
                        dispatch_semaphore_signal(sema);
                    }];
                });
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
            
        } else {
            NSLog(@"Uknown asset type");
        }
        NSError *error;
        [[[self class] managedObjectContext] save:&error];
        NSAssert(!error, @"%@", error);
    }
    
    
    //fetch Photo OrderBy Photo TimeStamp
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([DPhoto class]) inManagedObjectContext:[[self class] managedObjectContext]];
//    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"", ];
//    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime"
//                                                                   ascending:YES];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
//    
//    NSError *error = nil;
//    NSArray *fetchedObjects = [[[self class] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
//    if ([fetchedObjects count] > 0) {
//        DSign *currentSign = nil;
//        for(DPhoto *item in fetchedObjects){
//            if(currentSign){
//                if([[currentSign location] distanceFromLocation:[item location]] <= kMaxSignDistance){
//                    newSign = nil;
//                }
//            }
//            if(!newSign){
//                newSign = [DSign newSign];
//                [self.signs addObject:newSign];
//            }
//            [newSign addPhotosObject:item];
//            lastItem = item;
//        }
//    }
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
