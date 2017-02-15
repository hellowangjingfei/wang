//
//  ViewController.m
//  MapExampleDemo
//
//  Created by wangjingfei on 2016/12/27.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<MKMapViewDelegate>
{
    MKMapView *_mapView;
    
    UILabel *_userLocationLabel;//查看用户坐标
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)createMapView
{
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = YES;
    _mapView.scrollEnabled = YES;
    
    if ([CLLocationManager locationServicesEnabled] == YES) {
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    }
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}
#pragma mark -MKMapViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
