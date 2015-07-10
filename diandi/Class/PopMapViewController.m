//
//  PopMapViewController.m
//  diandi
//
//  Created by kjubo on 15/5/19.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "PopMapViewController.h"
#import "TourMainViewController.h"
#import "DAnnotation.h"
#import "PopAnnotationView.h"

#define ARC4RANDOM_MAX 0x100000000
#define FRAND(MIN, MAX) ((double)arc4random() / ARC4RANDOM_MAX) * (MAX - MIN)+ MIN

@interface PopMapViewController () <MKMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *arrMessage;
@property (nonatomic, strong) NSMutableArray *arrAnnotation;
@property (nonatomic, strong) NSTimer *timerForFetch;
@end

@implementation PopMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"行程" style:UIBarButtonItemStyleDone target:self action:@selector(navtoTourMainVc)];
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    
    self.arrAnnotation = [NSMutableArray array];
    self.arrMessage = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self clearTimer];
    self.timerForFetch = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(addRandomAnnototionView) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self clearTimer];
}

- (void)navtoTourMainVc{
    TourMainViewController *tvc = [[TourMainViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)clearTimer{
    if(self.timerForFetch){
        [self.timerForFetch invalidate];
        self.timerForFetch = nil;
    }
}

- (double)randomFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue{
    double rd = (double)arc4random() / ARC4RANDOM_MAX;
    return rd * (toValue - fromValue) + fromValue;
}

- (void)addRandomAnnototionView{
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mRect);
    double lat = [self randomFromValue:region.center.latitude - region.span.latitudeDelta * 0.5 toValue:region.center.latitude + region.span.latitudeDelta * 0.5];
    double lon = [self randomFromValue:region.center.longitude - region.span.longitudeDelta * 0.5 toValue:region.center.longitude + region.span.longitudeDelta * 0.5];
    DAnnotation *ann = [[DAnnotation alloc] init];
    ann.coordinate = CLLocationCoordinate2DMake(lat, lon);
    [self.arrAnnotation addObject:ann];
    [self.mapView addAnnotation:ann];
    
    if([self.arrAnnotation count] > kMaxAnnotationCount){
        [self.mapView removeAnnotation:[self.arrAnnotation firstObject]];
        [self.arrAnnotation removeObjectAtIndex:0];
    }
    
//    MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(lat, lon) radius:100000];
//    [self.mapView addOverlay:circle];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *cv = [[MKCircleRenderer alloc] initWithCircle:overlay];
        cv.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2];
        cv.lineWidth = 1;
        cv.strokeColor = RGBCOLOR(0xFF0000);
        return cv;
    }
    return nil;
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
    [aView setPhotoURL:@"http://pic5.bbzhi.com/fengjingbizhi/guangyuyingjiaozhideshengyandongjingdeyejing/guangyuyingjiaozhideshengyandongjingdeyejing_458219_2.jpg"];
    
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
