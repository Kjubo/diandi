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
#import "DAnnotation.h"
#import "DPhoto.h"
#import "DSign.h"
#import "PopAnnotationView.h"
#import "SignFolderView.h"

#define kMaxSignDistance 1000

@interface TourMainViewController () <ELCImagePickerControllerDelegate, MKMapViewDelegate>
@property (nonatomic, strong) ELCImagePickerController *imagePicker;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) SignFolderView *signFolderView;
@property (nonatomic, strong) NSMutableArray *signs;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *arrAnnotation;
@end

@implementation TourMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"照片+" style:UIBarButtonItemStyleDone target:self action:@selector(choosePhoto)];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    
    self.signFolderView = (SignFolderView *)[[NSBundle mainBundle] loadNibNamed:@"SignFolderView" owner:nil options:nil][0];
    [self.view addSubview:self.signFolderView];
    [self.signFolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.photos = [NSMutableArray array];
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
                        [self.photos addObject:ph];
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
//        NSError *error;
//        [[[self class] managedObjectContext] save:&error];
//        NSAssert(!error, @"%@", error);
    }
    
    for(int i = 0; i < [self.photos count]; i++){
        [self performSelector:@selector(addAnnototionView:) withObject:self.photos[i] afterDelay:i * 0.5];
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

- (void)addAnnototionView:(DPhoto *)photo{
    DAnnotation *ann = [[DAnnotation alloc] init];
    ann.coordinate = CLLocationCoordinate2DMake([photo.latitude doubleValue], [photo.longitude doubleValue]);
    [self.arrAnnotation addObject:ann];
    [self.mapView addAnnotation:ann];
    
    if([self.arrAnnotation count] > kMaxAnnotationCount){
        [self.mapView removeAnnotation:[self.arrAnnotation firstObject]];
        [self.arrAnnotation removeObjectAtIndex:0];
    }
    
    //    MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(lat, lon) radius:100000];
    //    [self.mapView addOverlay:circle];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *annIdentifier = @"PopAnnotationView";
    PopAnnotationView *aView = (PopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annIdentifier];
    if(!aView){
        aView = [[PopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annIdentifier];
        aView.borderColor = [UIColor greenColor];
        aView.canShowCallout = NO;
        aView.frame = CGRectMake(0, 0, 80, 105);
        aView.centerOffset = CGPointMake(0, -aView.frame.size.width * 0.5);
    }else{
        aView.annotation = annotation;
    }
    DAnnotation *ann = (DAnnotation *)annotation;
    DPhoto *photo = self.photos[[self.arrAnnotation indexOfObject:ann]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.uri]];
    aView.image = [UIImage imageWithData:data];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    for(id item in views){
        if([item isKindOfClass:[PopAnnotationView class]]){
            PopAnnotationView *pv = (PopAnnotationView *)item;
            CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            scale.removedOnCompletion = YES;
            scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            scale.repeatCount = 1;
            scale.duration = 0.6;
            [scale setValues:@[@(0.8), @(1.2), @(1.0)]];
            [pv.layer addAnimation:scale forKey:@"myScale"];
        }
    }
}

@end
