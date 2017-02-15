//
//  ViewController.m
//  MapDemo
//
//  Created by wangjingfei on 2016/12/27.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FirstViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface ViewController ()<CLLocationManagerDelegate,MAMapViewDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager; //定位管理器

@property (nonatomic,strong) MAMapView *mapView;//地图

@property (nonatomic,strong) CLGeocoder *lGeocoder;//地理编码

@property (nonatomic,assign) BOOL isFirstLocation;//首次定位

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    //定位管理器
//    _locationManager = [[CLLocationManager alloc] init];
////    if (IOS8) {
////        [_locationManager requestWhenInUseAuthorization];
////    }
//    if (![CLLocationManager locationServicesEnabled]) {
//        NSLog(@"定位服务当前可能尚未打开，请设置打开");
//        return;
//    }
//    
//    //如果没有授权则请求用户授权
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
//        [_locationManager requestWhenInUseAuthorization];
//    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
//        //设置代理
//        _locationManager.delegate = self;
//        //设置定位精度
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        //定位频率，每隔多少米定位一次
//        CLLocationDistance distance = 10.0;
//        _locationManager.distanceFilter = distance;
//        
//        //启动定位追踪
//        [_locationManager startUpdatingLocation];
//    }
//    
//    //地理编码
//    _lGeocoder = [[CLGeocoder alloc] init];
//    [self accordingToThePlaceNamesToDetermineTheLocation:@"新联大厦"];
    
    [self createMapView];
    
    //右边按钮
    [self createLeftButton];
}

//添加地图控件在页面
- (void)createMapView
{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 350)];
    [self.view addSubview:_mapView];
    
    //设置代理
    _mapView.delegate = self;
    
    //请求定位服务
    _locationManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记当前位置，此时会调用定位服务)
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType = MAMapTypeStandard;
    
    //是否显示用户的当前位置
    _mapView.showsUserLocation = YES;
    
    //显示用户所面朝的方向
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;

}
- (void)createLeftButton
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"显示用户所在区域" style:UIBarButtonItemStyleDone target:self action:@selector(leftItemClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)leftItemClick:(UIBarButtonItem *)item
{
//    Amapgeo
}
//#pragma mark -MKMapViewDelegate
//#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    NSLog(@"%@",userLocation);
//    userLocation.title = @"当前位置";
//    userLocation.subtitle = @"新联大厦";
//    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前位置为地图中心点)
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
//    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
//    [_mapView setRegion:region animated:YES];
//}
#pragma mark -MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //首次定位
    if (updatingLocation && !_isFirstLocation) {
        [_mapView setCenterCoordinate:userLocation.location.coordinate];
        _isFirstLocation = YES;
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = _mapView.userLocation.coordinate;
        pointAnnotation.title = @"我的位置";
        pointAnnotation.subtitle = @"";
        [_mapView addAnnotation:pointAnnotation];
    }
}
#pragma mark -添加大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *identifier = @"MapAnnotation";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        //如果缓存池中不存在则新建
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        //允许交互点击
        annotationView.canShowCallout = YES;
        //设置标注动画显示，默认为NO
        annotationView.animatesDrop = YES;
        
        //设置标志可以拖动，默认为NO
        annotationView.draggable = NO;
        
        annotationView.pinColor = MAPinAnnotationColorRed;
        
        return annotationView;
    }
    return nil;
    
}
//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//    NSLog(@"点击了annotationView");
//    FirstViewController *firstViewCtrl = [[FirstViewController alloc] init];
//    [self.navigationController pushViewController:firstViewCtrl animated:YES];
//}
#pragma mark -CLLocationManagerDelegate
//追踪定位代理方法，每次位置发生变化即会执行（只要定位到相应的位置）
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];//取得第一个位置
    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
    NSLog(@"经度:%f,纬度:%f,海拔:%f,航向:%f,行走速度:%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [_locationManager stopUpdatingLocation];
    NSDictionary *dic = @{@"latitude":[NSNumber numberWithDouble:coordinate.latitude],@"longitude":[NSNumber numberWithDouble:coordinate.longitude]};
    [self accordingToTheCoordinatesForNames:dic];
}
//根据地名确定地理位置
- (void)accordingToThePlaceNamesToDetermineTheLocation:(NSString *)address
{
    //地理编码
    [_lGeocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //获得第一个地标，地标中存储了详细的地址，注意：一个地名可能搜索出多个地址
        CLPlacemark *placeMark = [placemarks firstObject];
        //位置
        CLLocation *location = placeMark.location;
        //区域
        CLRegion *region = placeMark.region;
        NSLog(@"location--------%@,region-----------%@",location,region);
//        //详细地址信息字典，包含以下部分信息
//        NSDictionary *addressDic = placeMark.addressDictionary;
//        //地名
//        NSString *name = placeMark.name;
//        //街道
//        NSString *thoroghfare = placeMark.thoroughfare;
//        //街道的相关信息，例如门牌等
//        NSString *subThoroghfare = placeMark.subThoroughfare;
//        //城市
//        NSString *locality = placeMark.locality;
//        //城市的相关信息，例如标志性建筑等
//        NSString *subLocality = placeMark.subLocality;
//        //州
//        NSString *administrativeArea = placeMark.administrativeArea;
//        //其他行政区域信息
//        NSString *subAdministrativeArea = placeMark.subAdministrativeArea;
//        //邮编
//        NSString *postalCode = placeMark.postalCode;
//        //国家编码
//        NSString *ISOcouuntryCode = placeMark.ISOcountryCode;
//        //国家
//        NSString *country = placeMark.country;
//        //水源、胡泊
//        NSString *inLandWater = placeMark.inlandWater;
//        //海洋
//        NSString *ocean = placeMark.ocean;
//        //关联的或利益相关的地标
//        NSArray *areaOfInterest = placeMark.areasOfInterest;
    }];
}
//根据坐标获取地名
- (void)accordingToTheCoordinatesForNames:(NSDictionary *)dic
{
    //纬度
    CLLocationDegrees latitude = [[dic objectForKey:@"latitude"] doubleValue];
    //经度
    CLLocationDegrees longitude = [[dic objectForKey:@"longitude"] doubleValue];
    
    //反地理编译
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [_lGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        NSDictionary *addressDic = placeMark.addressDictionary;
        NSLog(@"addressDic------%@",addressDic);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
