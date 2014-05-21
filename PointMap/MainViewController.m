//
//  MainViewController.m
//  PointMap
//
//  Created by m_masanori on 2014/05/21.
//  Copyright (c) 2014年 masanori. All rights reserved.
//

#import "MainViewController.h"
#import <MapKit/MapKit.h>

@interface MainViewController () < CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mmvMap;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCurrentLocation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnStartLogging;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnStopLogging;
@property (strong, nonatomic) CLLocationManager	*clmLocationManager;

- (IBAction)btnCurrentLocationTouched:(id)sender;
- (IBAction)btnStartLoggingTouched:(id)sender;
- (IBAction)btnStopLoggingTouched:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [self prepareLocationManager];
    [self prepareTappingMapAction];
    [super viewDidLoad];
}
- (void)prepareLocationManager
{
    _clmLocationManager = [[CLLocationManager alloc] init];
    _clmLocationManager.delegate = self;
    // 位置情報の更新頻度
    _clmLocationManager.activityType = CLActivityTypeAutomotiveNavigation;
    // 位置情報取得の最短距離(m)
    _clmLocationManager.distanceFilter = kCLDistanceFilterNone;
    // 位置情報の取得制度
    _clmLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
}
- (void)prepareTappingMapAction
{
    // MapをTapした時にイベントを取得できるようにする
    UITapGestureRecognizer *tgrTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTouched:)];
    [tgrTapGesture setNumberOfTapsRequired:1];
    [_mmvMap addGestureRecognizer:tgrTapGesture];
}
- (void)viewDidAppear:(BOOL)animated {
    // ユーザーの動きに合わせてMapを追従させる
    [_mmvMap setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"UpdatedLocation");
}
- (void)mapTouched:(UITapGestureRecognizer *)sender
{
    // MapをTapした場所から緯度、経度を取得する
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint cgpTapPoint = [sender locationInView:self.view];
        CLLocationCoordinate2D clcTapLocation = [_mmvMap convertPoint:cgpTapPoint toCoordinateFromView:_mmvMap];
        NSLog(@"%f", clcTapLocation.latitude);
        NSLog(@"%f", clcTapLocation.longitude);
    }
}
- (IBAction)btnCurrentLocationTouched:(id)sender {
    // 地図の中心座標に現在地を設定
    MKCoordinateSpan mcsSpan = MKCoordinateSpanMake(0.5, 0.5);
    CLLocationCoordinate2D clcCenter = _mmvMap.userLocation.location.coordinate;
    MKCoordinateRegion mcrRegion = MKCoordinateRegionMake(clcCenter, mcsSpan);
    [_mmvMap setRegion:mcrRegion animated:YES];
}
- (IBAction)btnStartLoggingTouched:(id)sender {
    // 位置情報の更新を開始する
    [_clmLocationManager startUpdatingLocation];
    
    // 停止ボタンをEnabledにする
    _btnStartLogging.enabled = NO;
    _btnStopLogging.enabled = YES;
}

- (IBAction)btnStopLoggingTouched:(id)sender {
    // 位置情報の更新をストップする
    [_clmLocationManager stopUpdatingLocation];
    
    // 開始ボタンをEnabledにする
    _btnStartLogging.enabled = YES;
    _btnStopLogging.enabled = NO;
}


@end
