//
//  DDSpotMapViewController.m
//  diandi
//
//  Created by kjubo on 15/11/30.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotMapViewController.h"
#import "DAnnotation.h"

@interface DDSpotMapViewController ()<MKMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@end

static NSString *kPinReusableIdentifier = @"kPinReusableIdentifier";
@implementation DDSpotMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = [MKMapView new];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled = YES;
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = [self.model.title copy];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.model.lat, self.model.lng);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 3000.0, 3000.0);
    [self.mapView setRegion:region animated:YES];
    // Creates a marker in the center of the map.

    DAnnotation *ann = [[DAnnotation alloc] initWithCoordinates:location title:self.model.title subTitle:self.model.address];
    [self.mapView addAnnotation:ann];
    //自动显示标注的layout
    [self.mapView selectAnnotation:ann animated:YES];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if(![annotation isKindOfClass:[DAnnotation class]]
       || mapView != self.mapView){
        return nil;
    }
    
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kPinReusableIdentifier];
    if(annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinReusableIdentifier];
        [annotationView setCanShowCallout:YES];
    }
    return annotationView;
}

@end
