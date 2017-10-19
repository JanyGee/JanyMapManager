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
#import "GoogleLocationMarker.h"
#import "PaopaoCustomView.h"
#import "JanyGoogleGeoCodeSearch.h"
#import "GuiJiMarker.h"
#import "SnakeMarker.h"

@interface JanyGoogleMapView ()<GMSMapViewDelegate>
{
    CLLocationCoordinate2D _dvCLLocation;//设备位置
    CLLocationCoordinate2D _usCLLocation;//手机位置
    NSArray *_guijiModelArray;
    NSMutableArray *_coordinate2DArray;
    BOOL _firstLocationUpdate;
    NSObject *_dvInfor;//定位点相应气泡上的信息
    
    UIColor *_guijiLineColor;
    UIColor *_fenceStrokerColor;
    UIColor *_fenceFillColor;
    CGFloat _guijiLineWidth;
    
    UIImage *_startImage;
    UIImage *_endImage;
    UIImage *_middleImage;
    UIImage *_wifiImage;
    UIImage *_gpsImage;
    UIImage *_lbsImage;
}
@property (nonatomic, strong)GMSMapView *myMap;
@property (nonatomic, strong)GoogleLocationMarker *locationMarker;
@property (nonatomic, strong)JanyGoogleGeoCodeSearch *myGeocoder;
@property (nonatomic, strong)GMSPolyline *guijiLine;
@property (nonatomic, strong)GMSCoordinateBounds *camereBounds;
@property (nonatomic, strong)SnakeMarker *snakeMarker;
@property (nonatomic, strong)GMSPolyline *myPolyline;
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

- (GoogleLocationMarker *)locationMarker
{
    if (!_locationMarker) {
        _locationMarker = [[GoogleLocationMarker alloc] init];
    }
    
    return _locationMarker;
}

- (JanyGoogleGeoCodeSearch *)myGeocoder
{
    if (!_myGeocoder) {
        _myGeocoder = [[JanyGoogleGeoCodeSearch alloc] init];
    }
    return _myGeocoder;
}

- (GMSCoordinateBounds *)camereBounds
{
    if (!_camereBounds) {
        
        _camereBounds = [[GMSCoordinateBounds alloc] init];
    }
    
    return _camereBounds;
}

- (SnakeMarker *)snakeMarker
{
    if (!_snakeMarker) {
        _snakeMarker = [[SnakeMarker alloc] init];
    }
    
    return _snakeMarker;
}
#pragma mark ============================== delegate ==============================
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    marker.tracksInfoWindowChanges = YES;
    
    if ([marker isKindOfClass:[GoogleLocationMarker class]]) {
        PaopaoCustomView *customPaopo = [[PaopaoCustomView alloc] initWithFrame:CGRectMake(0.f, 0.f, 250, 150)];
        
        [self.myGeocoder reverseWithCoordinate2D:marker.position success:^(NSString *result) {
            
            [customPaopo setTitle:result];
            marker.tracksInfoWindowChanges = NO;
            
        } fail:^(NSError *error) {
            
            NSLog(@"reverse fail error code:%ld",(long)error.code);
            marker.tracksInfoWindowChanges = NO;
        }];
        
        return customPaopo;
    }
    
    if ([marker isKindOfClass:[GuiJiMarker class]]) {
        
        PaopaoCustomView *customPaopo = [[PaopaoCustomView alloc] initWithFrame:CGRectMake(0.f, 0.f, 250, 150)];
        
        [self.myGeocoder reverseWithCoordinate2D:marker.position success:^(NSString *result) {
            
            [customPaopo setTitle:result];
            marker.tracksInfoWindowChanges = NO;
            
        } fail:^(NSError *error) {
            
            NSLog(@"reverse fail error code:%ld",(long)error.code);
            marker.tracksInfoWindowChanges = NO;
        }];
        
        return customPaopo;
    }
    
    if ([marker isKindOfClass:[SnakeMarker class]]) {
        
        PaopaoCustomView *customPaopo = [[PaopaoCustomView alloc] initWithFrame:CGRectMake(0.f, 0.f, 250, 150)];
        
        [self.myGeocoder reverseWithCoordinate2D:marker.position success:^(NSString *result) {
            
            [customPaopo setTitle:result];
            marker.tracksInfoWindowChanges = NO;
            
        } fail:^(NSError *error) {
            
            NSLog(@"reverse fail error code:%ld",(long)error.code);
            marker.tracksInfoWindowChanges = NO;
        }];
        
        return customPaopo;
    }
    return nil;
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
- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType
{
    [self jany_locateWithCoordinate2D:coordinate2D Coordinate2DType:llType annotationImage:nil annotationInfor:nil success:nil fail:nil];
}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage
{
    [self jany_locateWithCoordinate2D:coordinate2D Coordinate2DType:llType annotationImage:annotationImage annotationInfor:nil success:nil fail:nil];
}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType success:(ReverseSuccess)success fail:(ReverseFail)fail
{
    [self jany_locateWithCoordinate2D:coordinate2D Coordinate2DType:llType annotationImage:nil annotationInfor:nil success:success fail:fail];
}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage success:(ReverseSuccess)success fail:(ReverseFail)fail
{
    [self jany_locateWithCoordinate2D:coordinate2D Coordinate2DType:llType annotationImage:annotationImage annotationInfor:nil success:success fail:fail];
}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage annotationInfor:(NSObject *)infor
{
    [self jany_locateWithCoordinate2D:coordinate2D Coordinate2DType:llType annotationImage:annotationImage annotationInfor:infor success:nil fail:nil];
}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage annotationInfor:(NSObject *)infor success:(ReverseSuccess)success fail:(ReverseFail)fail
{

    if (llType == Wgs84) {//坐标转换
        _dvCLLocation = coordinate2D;
    }else if (llType == Gcj02){
        _dvCLLocation = [JZLocationConverter gcj02ToWgs84:coordinate2D];
    }else{
        _dvCLLocation = [JZLocationConverter bd09ToWgs84:coordinate2D];
    }
    
    _dvInfor = infor;
    
    self.locationMarker.appearAnimation = kGMSMarkerAnimationPop;
    self.locationMarker.icon = annotationImage;
    self.locationMarker.position = _dvCLLocation;
    self.locationMarker.map = _myMap;
    [_myMap animateToLocation:_dvCLLocation];
    
    [self.myGeocoder reverseWithCoordinate2D:_dvCLLocation success:^(NSString *result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        
        fail();
    }];
}

#pragma mark ============================== 轨迹操作 ==============================
- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage endImage:(UIImage *)endImage
{
    [self jany_pathMoveWithData:dataArr coordinate2DType:llType startImage:startImage middleImage:nil endImage:endImage lineWidth:4 lineColor:[UIColor redColor]];
}
- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage middleImage:(UIImage *)img endImage:(UIImage *)endImage
{
    [self jany_pathMoveWithData:dataArr coordinate2DType:llType startImage:startImage middleImage:img endImage:endImage lineWidth:4 lineColor:[UIColor redColor]];
}

- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage wifiImgae:(UIImage *)wifiImgae gpsImage:(UIImage *)gpsImage lbsImage:(UIImage *)lbsImage endImage:(UIImage *)endImage
{
    [self jany_pathMoveWithData:dataArr coordinate2DType:llType startImage:startImage wifiImgae:wifiImgae gpsImage:gpsImage lbsImage:lbsImage endImage:endImage lineWidth:4 lineColor:[UIColor redColor]];
    
}

- (void)jany_imagePathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage middleImage:(UIImage *)img endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineImage:(UIImage *)lineImage
{
    [self jany_pathMoveWithData:dataArr coordinate2DType:llType startImage:startImage middleImage:img endImage:endImage lineWidth:width lineColor:nil];
}

- (void)jany_imagePathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage wifiImgae:(UIImage *)wifiImgae gpsImage:(UIImage *)gpsImage lbsImage:(UIImage *)lbsImage endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineImage:(UIImage *)lineImage
{
    
    [self jany_pathMoveWithData:dataArr coordinate2DType:llType startImage:startImage wifiImgae:wifiImgae gpsImage:gpsImage lbsImage:lbsImage endImage:endImage lineWidth:width lineColor:nil];
}

- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage middleImage:(UIImage *)img endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor
{

    _startImage = startImage;
    _endImage = endImage;
    _middleImage = img;
    _guijiLineWidth = width;
    _guijiLineColor = lineColor;
    
    
    _wifiImage = nil;
    _gpsImage = nil;
    _lbsImage = nil;
    
    
    if (img) {
        
        @synchronized (dataArr) {
            
            [self guijiAnnotation:dataArr coordinate2DType:llType];
        }
    }else{
        
        @synchronized (dataArr) {
            
            [self guijiNoAnnotation:dataArr coordinate2DType:llType];
        }
    }
}

- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage wifiImgae:(UIImage *)wifiImgae gpsImage:(UIImage *)gpsImage lbsImage:(UIImage *)lbsImage endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor
{
    _wifiImage = wifiImgae;
    _gpsImage = gpsImage;
    _lbsImage = lbsImage;
    _startImage = startImage;
    _endImage = endImage;
    _middleImage = nil;
    _guijiLineWidth = width;
    _guijiLineColor = lineColor;
    
    
    if (wifiImgae || gpsImage || lbsImage) {
        
        @synchronized (dataArr) {
            
            [self guijiAnnotation:dataArr coordinate2DType:llType];
        }
        
    }else{
        
        @synchronized (dataArr) {
            
            [self guijiNoAnnotation:dataArr coordinate2DType:llType];
        }
    }
}

- (void)guijiAnnotation:(NSArray *)arr coordinate2DType:(Coordinate2DType)llType
{
    [self jany_cleanAllFence];
    
    GMSMutablePath *pathLine = [GMSMutablePath path];
    
    for (int i = 0; i < arr.count; i ++) {
        
        Model *model = arr[i];
        CLLocationCoordinate2D LL = CLLocationCoordinate2DMake(model.lat,model.lon);
        
        if (llType == Wgs84) {//坐标转换
            LL = LL;
        }else if (llType == Gcj02){
            LL = [JZLocationConverter gcj02ToWgs84:LL];
        }else{
            LL = [JZLocationConverter bd09ToWgs84:LL];
        }
        
        [pathLine addCoordinate:LL];
        
        if (i > 0 && i < arr.count - 1 && arr.count > 3) {
            GuiJiMarker *marker = [[GuiJiMarker alloc] init];
            marker.position = LL;
            marker.map = _myMap;
            
            if (model.type == 0) {
                marker.icon = _wifiImage;
            }else if (model.type == 1){
                marker.icon = _gpsImage;
            }else if (model.type == 2){
                marker.icon = _lbsImage;
            }else{
                marker.icon = _middleImage;
            }
        }
        
        if (i == 0) {
            
            GuiJiMarker *startMarker = [[GuiJiMarker alloc] init];
            startMarker.icon = _startImage;
            startMarker.position = LL;
            startMarker.map = _myMap;
        }
        
        if (i == arr.count - 1) {
            
            GuiJiMarker *endMarker = [[GuiJiMarker alloc] init];
            endMarker.icon = _endImage;
            endMarker.position = LL;
            endMarker.map = _myMap;
        }
        
        self.camereBounds = [self.camereBounds includingCoordinate:LL];
    }
    
    _guijiLine = [GMSPolyline polylineWithPath:pathLine];
    _guijiLine.strokeColor = _guijiLineColor;
    _guijiLine.strokeWidth = _guijiLineWidth;
    _guijiLine.map = _myMap;
    
    [_myMap animateWithCameraUpdate:[GMSCameraUpdate fitBounds:_camereBounds withPadding:30.f]];
}

- (void)guijiNoAnnotation:(NSArray *)arr coordinate2DType:(Coordinate2DType)llType
{

    [self jany_cleanAllFence];
    
    GMSMutablePath *pathLine = [GMSMutablePath path];
    
    for (int i = 0; i < arr.count; i ++) {
        
        Model *model = arr[i];
        CLLocationCoordinate2D LL = CLLocationCoordinate2DMake(model.lat,model.lon);
        
        if (llType == Wgs84) {//坐标转换
            LL = LL;
        }else if (llType == Gcj02){
            LL = [JZLocationConverter gcj02ToWgs84:LL];
        }else{
            LL = [JZLocationConverter bd09ToWgs84:LL];
        }
        
        [pathLine addCoordinate:LL];
        
        if (i == 0) {
            
            GuiJiMarker *startMarker = [[GuiJiMarker alloc] init];
            startMarker.icon = _startImage;
            startMarker.position = LL;
            startMarker.map = _myMap;
        }
        
        if (i == arr.count - 1) {
            
            GuiJiMarker *endMarker = [[GuiJiMarker alloc] init];
            endMarker.icon = _endImage;
            endMarker.position = LL;
            endMarker.map = _myMap;
        }
        
        self.camereBounds = [self.camereBounds includingCoordinate:LL];
    }
    
    _guijiLine = [GMSPolyline polylineWithPath:pathLine];
    _guijiLine.strokeColor = _guijiLineColor;
    _guijiLine.strokeWidth = _guijiLineWidth;
    _guijiLine.map = _myMap;
    
    [_myMap animateWithCameraUpdate:[GMSCameraUpdate fitBounds:_camereBounds withPadding:30.f]];
}

- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType moveImage:(UIImage *)moveImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor
{
    if (dataArr.count == 0) {
        _snakeMarker.map = nil;
        return;
    }
    
    GMSMutablePath *pathLine = [GMSMutablePath path];
    @synchronized(dataArr){
        
        for (int i = 0; i < dataArr.count; i ++) {
            
            Model *model = dataArr[i];
            CLLocationCoordinate2D LL = CLLocationCoordinate2DMake(model.lat,model.lon);
            if (llType == Wgs84) {//坐标转换
                LL = LL;
            }else if (llType == Gcj02){
                LL = [JZLocationConverter gcj02ToWgs84:LL];
            }else{
                LL = [JZLocationConverter bd09ToWgs84:LL];
            }
            
            [pathLine addCoordinate:LL];
            
            if (i == dataArr.count - 1) {
                self.snakeMarker.position = LL;
                self.snakeMarker.icon = moveImage;
                self.snakeMarker.map = _myMap;
            }
        }
        
        if (_myPolyline) {
            _myPolyline.map = nil;
            _myPolyline = nil;
            
        }
        
        _myPolyline = [GMSPolyline polylineWithPath:pathLine];
        _myPolyline.strokeColor = lineColor;
        _myPolyline.strokeWidth = width;
        _myPolyline.map = _myMap;
    
    }
    
    [pathLine removeAllCoordinates];
}

- (void)jany_cleanAllFence
{
    [_myMap clear];
}
@end
