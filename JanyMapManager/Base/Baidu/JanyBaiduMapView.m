//
//  JanyBaiduMapView.m
//  MapManagerDemo
//
//  Created by Jany on 17/9/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JanyBaiduMapView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "UserLocation.h"
#import "JanyGeoCodeSearch.h"
#import "PointAnnotation.h"
#import "GuiJiAnnotation.h"
#import "PaopaoCustomView.h"

@interface JanyBaiduMapView ()<BMKMapViewDelegate>
{
    CLLocationCoordinate2D _dvCLLocation;//设备位置
    UIImage *_dvImage;//设备大头针图片
    NSObject *_dvInfor;//定位点相应气泡上的信息
    UIColor *_guijiLineColor;
    CGFloat _guijiLineWidth;
    
    UIImage *_startImage;
    UIImage *_endImage;
    NSMutableArray *_coordinate2DArray;
}
@property (nonatomic, strong)BMKMapView *myMap;
@property (nonatomic, strong)UserLocation *myPosition;
@property (nonatomic, strong)JanyGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong)PointAnnotation *pointAnnotation;
@property (nonatomic, strong)PaopaoCustomView *dvPaopaoView;
@property (nonatomic, strong)BMKPolyline *guijiLine;
@end

@implementation JanyBaiduMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dvCLLocation = CLLocationCoordinate2DMake(11110, 111110);
        
        [self addSubview:self.myMap];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dvCLLocation = CLLocationCoordinate2DMake(11110, 111110);

        [self addSubview:self.myMap];
    }
    return self;
}

#pragma mark ============================== setupUI ==============================
- (BMKMapView *)myMap
{
    if (!_myMap) {

        _myMap = [[BMKMapView alloc]initWithFrame:self.bounds];
        [_myMap setShowsUserLocation:YES];
        [_myMap setRotateEnabled:NO];
        [_myMap setZoomLevel:15.f];
        [_myMap setDelegate:self];
    }
    
    return _myMap;
}

- (PointAnnotation *)pointAnnotation
{
    if (!_pointAnnotation) {
        _pointAnnotation = [[PointAnnotation alloc] init];
        [_pointAnnotation setTag:1];
    }
    
    return _pointAnnotation;
}

- (PaopaoCustomView *)dvPaopaoView
{
    if (!_dvPaopaoView) {
        _dvPaopaoView = [[PaopaoCustomView alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 100.f)];
    }
    
    return _dvPaopaoView;
}

- (BMKPolyline *)guijiLine
{
    if (!_guijiLine) {
        _guijiLine = [[BMKPolyline alloc] init];
    }
    return _guijiLine;
}
#pragma mark ============================== 定位手机的当前位置 ==============================
- (UserLocation *)myPosition
{
    if (!_myPosition) {
        _myPosition = [[UserLocation alloc] initWithMap:_myMap];
    }
    
    return _myPosition;
}

#pragma mark ============================== 反转经纬度 ==============================
- (JanyGeoCodeSearch *)geoCodeSearch
{
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[JanyGeoCodeSearch alloc] init];
    }
    return _geoCodeSearch;
}

#pragma mark ============================== delegate ==============================
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated//渲染完成后执行
{
    if (mapView.zoomLevel == 21) {
        //由于俯视角度变化和放大级别不能同时进行，所以这样操作
        [mapView setOverlooking:-45.f];
    }
    
    if (mapView.zoomLevel < 15) {
        [mapView setOverlooking:0];
    }
    
}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[PointAnnotation class]]) {
        NSString *AnnotationViewID = @"deviceMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            
            if (_dvImage) {
                annotationView.image = _dvImage;
            }else{
                annotationView.pinColor = BMKPinAnnotationColorRed;
            }
            
            BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:self.dvPaopaoView];
            annotationView.paopaoView = paopao;
            annotationView.animatesDrop = YES;
            annotationView.draggable = YES;
        }
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[GuiJiAnnotation class]]) {
        NSString *AnnotationViewID = @"guijiMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            
            CLLocation *ll = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
            NSLog(@"点%f----%d---%d",ll.coordinate.latitude,[_coordinate2DArray indexOfObject:ll],_coordinate2DArray.count);
            if ([_coordinate2DArray indexOfObject:ll] == 0) {
                NSLog(@"起点%f",ll.coordinate.latitude);
                annotationView.pinColor = BMKPinAnnotationColorGreen;
            }else if ([_coordinate2DArray indexOfObject:ll] == _coordinate2DArray.count - 1){
                NSLog(@"终点");
                annotationView.pinColor = BMKPinAnnotationColorRed;
            }else{
                NSLog(@"中间点");
                annotationView.pinColor = BMKPinAnnotationColorPurple;
            }
            
            BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:self.dvPaopaoView];
            annotationView.paopaoView = paopao;
            annotationView.animatesDrop = YES;
            annotationView.draggable = YES;
        }
        return annotationView;
    }
    
    return nil;
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = _guijiLineColor;
        polylineView.lineWidth = _guijiLineWidth;

        return polylineView;
    }
    
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view.reuseIdentifier isEqualToString:@"deviceMark"]) {
        
        NSLog(@"I am renameMark.");
        
    }else if([view.reuseIdentifier isEqualToString:@"guijiMark"]){
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%d",arc4random()%10];
    [self.dvPaopaoView setTitle:str];
    NSLog(@"%f",view.annotation.coordinate);
}

#pragma mark ============================== 父类方法 ==============================
- (void)setMapDispalyType:(MapDisplayType)mapDispalyType
{
    switch (mapDispalyType) {
        case MapNormal:
            [_myMap setMapType:BMKMapTypeStandard];
            [_myMap setOverlooking:3.f];
            break;
        case MapSatellite:
            [_myMap setMapType:BMKMapTypeSatellite];
            [_myMap setOverlooking:3.f];
            break;
        case Map3D:
            [_myMap setMapType:BMKMapTypeStandard];
            [_myMap setZoomLevel:21];
            break;
        default:
            break;
    }
}

- (void)startLocationSuccess:(void (^)(void))success fail:(void (^)(NSError *))fail
{
    __weak typeof (self)weakSelf = self;
    [self.myPosition startLocationSuccess:^(CLLocationCoordinate2D ll) {
        success();
        
        if (CLLocationCoordinate2DIsValid(_dvCLLocation)) {
            
            CLLocationCoordinate2D coors[2];
            coors[0] = ll;
            coors[1] = _dvCLLocation;
            [weakSelf mapViewFitPolyLine:[BMKPolyline polylineWithCoordinates:coors count:2]];
             
        }else{
            
            CLLocationCoordinate2D coors[1];
            coors[0] = ll;
            [weakSelf mapViewFitPolyLine:[BMKPolyline polylineWithCoordinates:coors count:1]];
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

- (void)stopLocation
{
    [self.myPosition stopLocation];
}

#pragma mark ============================== 定位 ==============================
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
        _dvCLLocation = [JZLocationConverter wgs84ToBd09:coordinate2D];
    }else if (llType == Gcj02){
        _dvCLLocation = [JZLocationConverter gcj02ToBd09:coordinate2D];
    }else{
        _dvCLLocation = coordinate2D;
    }
    
    _dvImage = annotationImage;
    _dvInfor = infor;
    
    [_myMap setCenterCoordinate:_dvCLLocation animated:YES];
    
    [self.pointAnnotation setCoordinate:_dvCLLocation];
    [_myMap addAnnotation:_pointAnnotation];
    
    if (success && fail) {
        
        [self.geoCodeSearch reverseWithCoordinate2D:_dvCLLocation success:^(BMKReverseGeoCodeResult *result) {
            success(result.address);
        } fail:^(BMKSearchErrorCode error) {
            fail();
        }];
    }
}

#pragma mark ============================== 轨迹操作 ==============================

- (void)jany_pathMoveWithData:(NSArray *)dataArr startImage:(UIImage *)startImage endImage:(UIImage *)endImage
{
    [self jany_pathMoveWithData:dataArr withAnnotation:NO startImage:nil endImage:nil lineWidth:4 lineColor:[UIColor redColor]];
}

- (void)jany_pathMoveWithData:(NSArray *)dataArr withAnnotation:(BOOL)flag startImage:(UIImage *)startImage endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor
{
    /*
     百度地图画轨迹不会出现卡顿现象
     若果在轨迹点上一次添加的大头针的数量太多会造成卡顿现象，这样会影响体验感
      |
     \|/
     解决这种情况：
     此方法值调用一次，然后对数据进行分段处理，绘制完成之后再绘制下一组数据
     */
    
    _startImage = startImage;
    _endImage = endImage;
    _guijiLineWidth = width;
    _guijiLineColor = lineColor;

    if (flag) {//带大头针的轨迹
        
    }else{//不带中间大头针的轨迹
        [self guijiNoAnnotation:dataArr];
    }
}

- (void)guijiNoAnnotation:(NSArray *)arr
{
    _coordinate2DArray = [NSMutableArray arrayWithCapacity:12];
    NSMutableArray *arrAnnotation = [NSMutableArray array];
    CLLocationCoordinate2D coors[arr.count];
    for (int i = 0; i < arr.count; i ++) {
        
        Model *model = arr[i];
        CLLocationCoordinate2D LL = CLLocationCoordinate2DMake(model.lat,model.lon);
        coors[i] = LL;
        
        CLLocation *objLL = [[CLLocation alloc] initWithLatitude:model.lat longitude:model.lon];
        [_coordinate2DArray addObject:objLL];
        
        GuiJiAnnotation *annotation = [[GuiJiAnnotation alloc] init];
        [annotation setCoordinate:LL];
        [arrAnnotation addObject:annotation];
    }
    
    [_myMap addAnnotations:arrAnnotation];
    
    if ([self.guijiLine setPolylineWithCoordinates:coors count:arr.count]) {
        [_myMap addOverlay: _guijiLine];
        [self mapViewFitPolyLine:_guijiLine];
    }
}

#pragma mark ============================== 返回地图可视区域 ==============================
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_myMap setVisibleMapRect:rect];
    _myMap.zoomLevel = _myMap.zoomLevel - 0.3;
}
@end
