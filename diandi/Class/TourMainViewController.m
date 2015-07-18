//
//  TourMainViewController.m
//  diandi
//
//  Created by kjubo on 15/4/16.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "TourMainViewController.h"
#import "CTAssetsPickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSDate+Addition.h"
#import "CLLocation+Addtion.h"
#import "DAnnotation.h"
#import "DPhoto.h"
#import "PopAnnotationView.h"
#import "SignFolderView.h"
#import "DBSCAN.h"

#define kMaxSignDistance 1000

@interface TourMainViewController () <CTAssetsPickerControllerDelegate, MKMapViewDelegate>
@property (nonatomic, strong) CTAssetsPickerController *imagePicker;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) SignFolderView *signFolderView;
@property (nonatomic, strong) NSMutableArray *arrAnnotation;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *dataSource;
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
        make.edges.equalTo(self.view);
    }];
    
    self.signFolderView = (SignFolderView *)[[NSBundle mainBundle] loadNibNamed:@"SignFolderView" owner:nil options:nil][0];
    [self.view addSubview:self.signFolderView];
    [self.signFolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.photos = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
}

- (void)choosePhoto{
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - ELCImagePickerControllerDelegate
- (CTAssetsPickerController *)imagePicker{
    if(!_imagePicker){
        _imagePicker = [[CTAssetsPickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.showsCancelButton = YES;
        _imagePicker.showsNumberOfAssets = YES;
        _imagePicker.assetsFilter = [ALAssetsFilter allPhotos];
        _imagePicker.title = @"添加照片";
    }
    return _imagePicker;
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [self dismissViewControllerAnimated:YES completion:nil];
    if([assets count] <= 0) return;

    for (ALAsset *asset in assets) {
        CLLocation *loc = [asset valueForProperty:ALAssetPropertyLocation];
        NSDate *timestamp = [asset valueForProperty:ALAssetPropertyDate];
        DPhoto *ph = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DPhoto class]) inManagedObjectContext:[RootViewController managedObjectContext]];
        if(loc){
            ph.latitude = @(loc.coordinate.latitude);
            ph.longitude = @(loc.coordinate.longitude);
        }
        ph.timestamp = timestamp;
        ph.originalUri = asset.defaultRepresentation.url.absoluteString;
        ph.thumbnailImage = UIImagePNGRepresentation([UIImage imageWithCGImage:asset.thumbnail]);
        ph.uuid = [[NSUUID UUID] UUIDString];
        [self.photos addObject:ph];
    }
    
    DBSCAN *cluter = [[DBSCAN alloc] initWithRadius:100.0 minNumberOfPointsInCluster:1 andDistanceCalculator:^float(id obj1, id obj2) {
        CLLocation *loc1 = nil;
        CLLocation *loc2 = nil;
        DPhoto *photo1 = (DPhoto *)obj1;
        DPhoto *photo2 = (DPhoto *)obj2;
        if(photo1.latitude && photo1.longitude){
            loc1 = [[CLLocation alloc] initWithLatitude:[photo1.latitude doubleValue] longitude:[photo1.longitude doubleValue]];
        }
        if(photo2.latitude && photo2.longitude){
            loc2 = [[CLLocation alloc] initWithLatitude:[photo2.latitude doubleValue] longitude:[photo2.longitude doubleValue]];
        }
        
        if(!loc1 && !loc2){ //都没有经纬度
           return 0;
        }else if(!loc1 || !loc2){   //有一个没有经纬度
            return CGFLOAT_MAX;
        }else{  //返回距离
            return [loc1 distanceFromLocation:loc2];
        }
    }];
    self.dataSource = [NSMutableArray arrayWithArray:[cluter clustersFromPoints:self.photos]];
    self.signFolderView.data = self.dataSource;
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
//    DPhoto *photo = self.photos[[self.arrAnnotation indexOfObject:ann]];
//    aView.image = [UIImage imageWithData:photo.thumbnailImage];
    
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
            scale.duration = 0.4;
            [scale setValues:@[@(0.8), @(1.2), @(1.0)]];
            [pv.layer addAnimation:scale forKey:@"myScale"];
        }
    }
}

@end
