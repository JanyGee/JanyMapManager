//
//  JanyGoogleMapView.m
//  MapManagerDemo
//
//  Created by Jany on 17/9/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JanyGoogleMapView.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSMarker.h>
#import <GoogleMaps/GMSPolyline.h>

@interface JanyGoogleMapView ()<GMSMapViewDelegate>
{
    CLLocationCoordinate2D _dvCLLocation;//设备位置
    CLLocationCoordinate2D _usCLLocation;//手机位置
    NSArray *_guijiModelArray;
    NSMutableArray *_coordinate2DArray;
    BOOL _firstLocationUpdate;
    UIImage *_dvImage;//设备大头针图片
    NSObject *_dvInfor;//定位点相应气泡上的信息
}
@property (nonatomic, strong)GMSMapView *myMap;
@end
@implementation JanyGoogleMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dvCLLocation = CLLocationCoordinate2DMake(11110, 111110);
        [self addSubview:self.myMap];
        
        [self initDataForMap];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dvCLLocation = CLLocationCoordinate2DMake(11110, 111110);
        [self addSubview:self.myMap];
        
        [self initDataForMap];
        
    }
    return self;
}

#pragma mark ============================== 初始化数据 ==============================
- (void)initDataForMap
{
    _coordinate2DArray = [NSMutableArray arrayWithCapacity:20];
    _guijiModelArray = [NSArray array];
}

#pragma mark ============================== setupUI ==============================
- (GMSMapView *)myMap
{
    if (!_myMap) {
        
        _myMap = [[GMSMapView alloc]initWithFrame:self.bounds];
        [_myMap setDelegate:self];
        
        [_myMap addObserver:self
                   forKeyPath:@"myLocation"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
        _myMap.myLocationEnabled = YES;
    }
    
    return _myMap;
}

#pragma mark ============================== 父类方法 ==============================
- (void)setMapDispalyType:(MapDisplayType)mapDispalyType
{
    switch (mapDispalyType) {
        case MapNormal:
        {
            [_myMap setMapType:kGMSTypeNormal];
            
            CLLocationCoordinate2D LL;
            if (CLLocationCoordinate2DIsValid(_dvCLLocation)) {
                LL = _dvCLLocation;
            }else{
                LL = CLLocationCoordinate2DMake(_usCLLocation.latitude, _usCLLocation.longitude);
            }
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:LL.latitude
                                                                    longitude:LL.longitude
                                                                         zoom:15.f
                                                                      bearing:0.f
                                                                 viewingAngle:0.f];
            [_myMap animateToCameraPosition:camera];
            camera = nil;
        }
            
            break;
        case MapSatellite:
        {
            [_myMap setMapType:kGMSTypeSatellite];
            
            CLLocationCoordinate2D LL;
            if (CLLocationCoordinate2DIsValid(_dvCLLocation)) {
                LL = _dvCLLocation;
            }else{
                LL = CLLocationCoordinate2DMake(_usCLLocation.latitude, _usCLLocation.longitude);
            }
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:LL.latitude
                                                                    longitude:LL.longitude
                                                                         zoom:15.f
                                                                      bearing:0.f
                                                                 viewingAngle:0.f];
            [_myMap animateToCameraPosition:camera];
            camera = nil;
        }
            break;
        case Map3D:
        {
            [_myMap setMapType:kGMSTypeNormal];
            
            CLLocationCoordinate2D LL;
            if (CLLocationCoordinate2DIsValid(_dvCLLocation)) {
                LL = _dvCLLocation;
            }else{
                LL = CLLocationCoordinate2DMake(_usCLLocation.latitude, _usCLLocation.longitude);
            }
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:LL.latitude
                                                                    longitude:LL.longitude
                                                                         zoom:15.f
                                                                      bearing:0.f
                                                                 viewingAngle:90.f];
            [_myMap animateToCameraPosition:camera];
            camera = nil;
        }
            break;
        default:
            break;
    }
}

- (void)dealloc
{
    [_myMap removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

#pragma mark ============================== KVO updates ==============================
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!_firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        _firstLocationUpdate = YES;
        _myMap.myLocationEnabled = NO;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _usCLLocation = location.coordinate;
        
        _myMap.camera = [GMSCameraPosition cameraWithTarget:_usCLLocation
                                                         zoom:14];
    }
}

#pragma mark ============================== 定位操作 ==============================
- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage annotationInfor:(NSObject *)infor success:(ReverseSuccess)success fail:(ReverseFail)fail
{

    if (llType == Wgs84) {//坐标转换
        _dvCLLocation = coordinate2D;
    }else if (llType == Gcj02){
        _dvCLLocation = [JZLocationConverter gcj02ToWgs84:coordinate2D];
    }else{
        _dvCLLocation = [JZLocationConverter bd09ToWgs84:coordinate2D];
    }
    
    _dvImage = annotationImage;
    _dvInfor = infor;
}

@end
