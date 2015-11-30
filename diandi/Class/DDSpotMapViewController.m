//
//  DDSpotMapViewController.m
//  diandi
//
//  Created by kjubo on 15/11/30.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
@interface DDSpotMapViewController ()
@property (nonatomic, strong) GMSMapView *mapView;
@end

@implementation DDSpotMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = [GMSMapView new];
    self.mapView.myLocationEnabled = NO;
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = [self.model.title copy];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.model.lat
                                                            longitude:self.model.lng
                                                                 zoom:6];
    [self.mapView setCamera:camera];
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.model.lat, self.model.lng);
    marker.title = [self.model.title copy];
    marker.snippet = [self.model.address copy];
    marker.map = self.mapView;
}

@end
