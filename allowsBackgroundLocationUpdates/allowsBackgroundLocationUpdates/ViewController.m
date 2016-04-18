//
//  ViewController.m
//  allowsBackgroundLocationUpdates
//
//  Created by zzw on 16/4/18.
//  Copyright © 2016年 zzw. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView * _mapView;
    CLLocationManager* _locationManager;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //实例化地图视图
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    //设置地图显示模式
    /*
     //    MKMapTypeStandard = 0, // 标准地图
     //    MKMapTypeSatellite, // 卫星云图
     //    MKMapTypeHybrid, // 混合(在卫星云图上加了标准地图的覆盖层)
     //    MKMapTypeSatelliteFlyover NS_ENUM_AVAILABLE(10_11, 9_0), // 3D立体
     //    MKMapTypeHybridFlyover NS_ENUM_AVAILABLE(10_11, 9_0), // 3D混合
     */
    
    _mapView.mapType = MKMapTypeSatelliteFlyover;
    //设置显示缩放比例
    _mapView.showsScale = YES;
    //设置显示用去当前位置
    _mapView.showsUserLocation=YES;
    [self setMapLatitude:39.915352 longitude:116.397105];
    [self.view addSubview:_mapView];
    //设置代理
    _mapView.delegate = self;
    //添加点击手势
    UITapGestureRecognizer * tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
    [_mapView addGestureRecognizer:tapGr];
    //配置定位管理
    [self getLocationInfo];
}
//设置地图显示的区域
- (void)setMapLatitude:(double)latitude longitude:(double)longitude{
    //坐标信息
    CLLocationCoordinate2D  Coordinate ;
    Coordinate.latitude = latitude;
    Coordinate.longitude = longitude;
    //设置米跨度大小信息
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    //设置显示区域
    MKCoordinateRegion region;
    region.center = Coordinate;
    region.span= span;
    //另一种显示
    //   region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), MKCoordinateSpanMake(0.02, 0.02));
    //调整地图的显示区域
    [_mapView setRegion:region animated:YES];
    
}
//配置定位管理对象
- (void)getLocationInfo{
    //实例化Manager
    _locationManager = [[CLLocationManager alloc] init];
    //设置代理
    _locationManager.delegate =self;
    //设置定位精度
    //定位要求的精度越高、属性distanceFilter的值越小，应用程序的耗电量就越大。
    /*
     extern const CLLocationAccuracy kCLLocationAccuracyBestForNavigation __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
     extern const CLLocationAccuracy kCLLocationAccuracyBest;
     extern const CLLocationAccuracy kCLLocationAccuracyNearestTenMeters;
     extern const CLLocationAccuracy kCLLocationAccuracyHundredMeters;
     extern const CLLocationAccuracy kCLLocationAccuracyKilometer;
     extern const CLLocationAccuracy kCLLocationAccuracyThreeKilometers;
     */
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位距离
    _locationManager.distanceFilter = 50;
    //申请地位许可 ios8 以后需要申请许可
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //真机测试  否则会爆
    
//    if (![CLLocationManager locationServicesEnabled]) {
//        NSLog(@"请开启定位:设置 -> 隐私 -> 位置 -> 定位服务");
//    }
//    //永久授权
//    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [_locationManager requestAlwaysAuthorization];
//    }
//    //开启后台定位
//    if ([_locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]) {
//        [_locationManager setAllowsBackgroundLocationUpdates:YES];
//    }
//    _locationManager.pausesLocationUpdatesAutomatically = NO;
}
//开始定位
- (IBAction)startLocation:(id)sender {
    [_locationManager startUpdatingLocation];
}

#pragma mark -点击手势 触摸定位-
- (void)tapGR:(UITapGestureRecognizer*)tapGr{
    
    //获取点击的坐标
    CGPoint touchPoint = [tapGr locationInView:_mapView];
    CLLocationCoordinate2D touchCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    NSLog(@"-->%f -->%f",touchCoordinate.latitude,touchCoordinate.longitude);
    [self setMapLatitude:touchCoordinate.latitude longitude:touchCoordinate.longitude];
    
    
    //在对应位置添加一个大头针
    MyAnnotation * annotation = [[MyAnnotation alloc] init];
    [annotation setCoordinate:touchCoordinate];
    annotation.title =@"故宫";
    annotation.subtitle = @"haogui";
    [_mapView addAnnotation:annotation];
}

#pragma mark - CLLocationManagerDelegate 定位-
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"位置信息:%@",locations);
    //调整当前位置
    CLLocation * location = [locations lastObject];
    //显示当前位置
    [self  setMapLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
#pragma mark -MKMapViewDelegate 设置大头针View-
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKAnnotationView * annotationView = nil;
    //判断是否是我们自己定义的大头针的类
    if (![annotation isKindOfClass:[MyAnnotation class]]) {
        return nil;
    }
    //判断地图是否是我我们期望的视图
    if (mapView != _mapView) {
        return annotationView;
    }
    //出队列一个大头针视图
    MKPinAnnotationView  * pinAnnottationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"xxx"];
    if (!pinAnnottationView) {
        pinAnnottationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"xxx"];
        //允许显示详情
        pinAnnottationView.canShowCallout=YES;
        
        
    }
    //右侧详情按钮
    UIButton * infoBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    pinAnnottationView.rightCalloutAccessoryView = infoBtn;
    //是否透明
    pinAnnottationView.opaque = NO;
    //是否向下下落效果
    pinAnnottationView.animatesDrop = YES;
    //是否可拖动
    pinAnnottationView.draggable = YES;
    //设置偏移量
    pinAnnottationView.calloutOffset = CGPointMake(0, 0);
    //创建一张图片的显示
    UIImageView * imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aaa"]];
    pinAnnottationView.leftCalloutAccessoryView = imgV;
    return pinAnnottationView;
}


@end
