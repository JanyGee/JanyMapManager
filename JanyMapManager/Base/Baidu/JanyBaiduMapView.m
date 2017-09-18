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
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "UserLocation.h"
#import "JanyGeoCodeSearch.h"
#import "PointAnnotation.h"
#import "GuiJiAnnotation.h"
#import "PaopaoCustomView.h"
#import "MovePolyline.h"
#import "MovePointAnnotation.h"
#import "FenceCentreAnnotation.h"
#import "BMKClusterManager.h"

@interface JanyBaiduMapView ()<BMKMapViewDelegate>
{
    CLLocationCoordinate2D _dvCLLocation;//设备位置
    UIImage *_dvImage;//设备大头针图片
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
    UIImage *_moveImage;
    UIImage *_fenceImage;
    UIImage *_guijiLineImage;
    NSArray *_guijiModelArray;
    NSMutableArray *_coordinate2DArray;

    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注
}
@property (nonatomic, strong)BMKMapView *myMap;
@property (nonatomic, strong)UserLocation *myPosition;
@property (nonatomic, strong)JanyGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong)PointAnnotation *pointAnnotation;
@property (nonatomic, strong)PaopaoCustomView *locatePaopao;
@property (nonatomic, strong)BMKPolyline *guijiLine;
@property (nonatomic, strong)MovePolyline *movePolyLine;
@property (nonatomic, strong)MovePointAnnotation *movePointAnnotation;
@property (nonatomic, strong)BMKPinAnnotationView *animationPinAnnotationView;
@property (nonatomic, strong)FenceCentreAnnotation *fenceAnnotation;
@property (nonatomic, strong)BMKClusterManager *clusterManager;
@end

@implementation JanyBaiduMapView

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

- (MovePointAnnotation *)movePointAnnotation
{
    if (!_movePointAnnotation) {
        _movePointAnnotation = [[MovePointAnnotation alloc] init];
    }
    
    return _movePointAnnotation;
}

- (FenceCentreAnnotation *)fenceAnnotation
{
    if (!_fenceAnnotation) {
        _fenceAnnotation = [[FenceCentreAnnotation alloc] init];
    }
    
    return _fenceAnnotation;
}

- (BMKPolyline *)guijiLine
{
    if (!_guijiLine) {
        _guijiLine = [[BMKPolyline alloc] init];
    }
    return _guijiLine;
}

- (MovePolyline *)movePolyLine
{
    if (!_movePolyLine) {
        _movePolyLine = [[MovePolyline alloc] init];
    }
    return _movePolyLine;
}

- (PaopaoCustomView *)locatePaopao
{
    if (!_locatePaopao) {
        _locatePaopao = [[PaopaoCustomView alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 100)];
    }
    return _locatePaopao;
}

- (BMKClusterManager *)clusterManager
{
    if (!_clusterManager) {
        _clusterManager = [[BMKClusterManager alloc] init];
    }
    return _clusterManager;
}

#pragma mark ============================== 初始化数据 ==============================
- (void)initDataForMap
{
    _coordinate2DArray = [NSMutableArray arrayWithCapacity:20];
    _guijiModelArray = [NSArray array];

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

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (_animationPinAnnotationView.selected) {
        [_animationPinAnnotationView setSelected:NO animated:YES];
        [_animationPinAnnotationView.paopaoView removeFromSuperview];
    }
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    if (_coordinate2DArray.count > 0) {
        [self updateClusters];
    }
}

- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel && _coordinate2DArray.count > 0) {
        [self updateClusters];
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
            
            BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:self.locatePaopao];
            annotationView.paopaoView = paopao;
            [annotationView setCalloutOffset:CGPointMake(0, -10)];
            
            _animationPinAnnotationView = annotationView;
        }
        
        if (_dvImage) {
            annotationView.image = _dvImage;
        }else{
            annotationView.pinColor = BMKPinAnnotationColorGreen;
        }
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MovePointAnnotation class]]) {
        NSString *AnnotationViewID = @"moveMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            
        }
        
        BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:[[PaopaoCustomView alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 100.f)]];
        annotationView.paopaoView = paopao;
        
        if (_moveImage) {
            annotationView.image = _moveImage;
        }else{
            annotationView.pinColor = BMKPinAnnotationColorGreen;
        }
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[GuiJiAnnotation class]]) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:annotation.coordinate.latitude ],@"lat",[NSNumber numberWithDouble:annotation.coordinate.longitude],@"lon", nil];
        
        NSString *AnnotationViewID = @"guijiMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];

        }
        
        BMKActionPaopaoView *paopao = [[BMKActionPaopaoView alloc] initWithCustomView:[[PaopaoCustomView alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 100.f)]];
        annotationView.paopaoView = paopao;
        [annotationView setCalloutOffset:CGPointMake(0, -10)];

        if ([_coordinate2DArray indexOfObject:dic] == 0) {
            //轨迹起点
            if (_startImage) {
                annotationView.image = _startImage;
            }else{
                annotationView.pinColor = BMKPinAnnotationColorGreen;
            }
            
        }else if ([_coordinate2DArray indexOfObject:dic] == _coordinate2DArray.count - 1){
            //轨迹终点
            if (_endImage) {
                annotationView.image = _endImage;
            }else{
                annotationView.pinColor = BMKPinAnnotationColorRed;
            }
            
        }else{
            
            
            //中间点,如果要区分中间点的定位类型，可以根据_guijiModelArray的model类型来切换图片
            //NSLog(@"%d----%d",_coordinate2DArray.count,_guijiModelArray.count);
            NSUInteger index = [_coordinate2DArray indexOfObject:dic];
            NSAssert(index != NSNotFound, @"数组里面的数据还没有完全同步，造成数据不一致");
            if (index != NSNotFound) {
                
                Model *model = _guijiModelArray[index];
                
                if (model.type == 0) {
                    annotationView.image = _wifiImage;
                }else if (model.type == 1){
                    annotationView.image = _gpsImage;
                }else if (model.type == 2){
                    annotationView.image = _lbsImage;
                }else{
                    annotationView.image = _middleImage;
                }
                
            }
        
        }
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[FenceCentreAnnotation class]]) {
        NSString *AnnotationViewID = @"fenceMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            
        }
        
        CGRect endFrame = annotationView.frame;
        annotationView.frame = CGRectOffset(endFrame, 0.f, -30.f);
        [UIView animateWithDuration:2.f delay:0.f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            annotationView.frame = endFrame;
        } completion:^(BOOL finished) {
            
        }];
        
        if (_fenceImage) {
            annotationView.image = _fenceImage;
        }else{
            annotationView.pinColor = BMKPinAnnotationColorGreen;
        }
        
        return annotationView;
    }
    
    return nil;
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]){

        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.lineWidth = _guijiLineWidth;
        
        if (_guijiLineColor) {
            
            polylineView.strokeColor = _guijiLineColor;
            
        }else{
            
            [polylineView loadStrokeTextureImage:_guijiLineImage];
        }
        
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[BMKCircle class]]) {
     
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.strokeColor = _fenceStrokerColor;
        circleView.fillColor = _fenceFillColor;
        circleView.lineWidth = 1.f;
        
        return circleView;
    }
    
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //走此函数说明有值
    if ([view.reuseIdentifier isEqualToString:@"deviceMark"]) {

        [UIView animateWithDuration:0.3f animations:^{
            view.transform = CGAffineTransformScale(view.transform, 1.2f, 1.2f);
        }];
        
    }else if([view.reuseIdentifier isEqualToString:@"guijiMark"]){
        
        PaopaoCustomView *linePaopao = view.paopaoView.subviews[0];
        
        [UIView animateWithDuration:0.3f animations:^{
            view.transform = CGAffineTransformScale(view.transform, 1.2f, 1.2f);
        }];
        
        [self.geoCodeSearch reverseWithCoordinate2D:view.annotation.coordinate success:^(BMKReverseGeoCodeResult *result) {
            [linePaopao setTitle:result.address];
        } fail:^(BMKSearchErrorCode error) {
            [linePaopao setTitle:@"反转失败"];
        }];
    }else if ([view.reuseIdentifier isEqualToString:@"moveMark"]){
        
        PaopaoCustomView *movePaopao = view.paopaoView.subviews[0];
        
        [self.geoCodeSearch reverseWithCoordinate2D:view.annotation.coordinate success:^(BMKReverseGeoCodeResult *result) {
            [movePaopao setTitle:result.address];
        } fail:^(BMKSearchErrorCode error) {
            [movePaopao setTitle:@"反转失败"];
        }];
    }
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if ([view.reuseIdentifier isEqualToString:@"deviceMark"]) {

        [UIView animateWithDuration:0.3f animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
        
    }else if ([view.reuseIdentifier isEqualToString:@"guijiMark"]){
        
        [UIView animateWithDuration:0.3f animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
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
            [_locatePaopao setTitle:result.address];
        } fail:^(BMKSearchErrorCode error) {
            fail();
            [_locatePaopao setTitle:@"反转失败"];
        }];
    }
    
    //大头针动画
    CGRect endFrame = _animationPinAnnotationView.frame;
    _animationPinAnnotationView.frame = CGRectOffset(endFrame, 0.f, -30.f);
    [UIView animateWithDuration:2.f delay:0.f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        _animationPinAnnotationView.frame = endFrame;
    } completion:^(BOOL finished) {
        
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
    _guijiLineImage = lineImage;
    [self jany_pathMoveWithData:dataArr coordinate2DType:llType startImage:startImage middleImage:img endImage:endImage lineWidth:width lineColor:nil];
}

- (void)jany_imagePathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage wifiImgae:(UIImage *)wifiImgae gpsImage:(UIImage *)gpsImage lbsImage:(UIImage *)lbsImage endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineImage:(UIImage *)lineImage
{
    _guijiLineImage = lineImage;
    
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

- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType moveImage:(UIImage *)moveImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor
{
    if (dataArr.count == 0) {
        [_myMap removeAnnotation:_movePointAnnotation];
        return;
    }

    @synchronized(dataArr){
    
        CLLocationCoordinate2D coors[dataArr.count];
        for (int i = 0; i < dataArr.count; i ++) {
            
            Model *model = dataArr[i];
            CLLocationCoordinate2D LL = CLLocationCoordinate2DMake(model.lat,model.lon);
            if (llType == Wgs84) {//坐标转换
                LL = [JZLocationConverter wgs84ToBd09:LL];
            }else if (llType == Gcj02){
                LL = [JZLocationConverter gcj02ToBd09:LL];
            }else{
                LL = LL;
            }
            
            coors[i] = LL;
        }
        
        _moveImage = moveImage;
        _guijiLineWidth = width;
        _guijiLineColor = lineColor;
        
        CLLocationCoordinate2D lastLL = coors[dataArr.count - 1];
        
        if ([self.movePolyLine setPolylineWithCoordinates:coors count:dataArr.count]) {
            [_myMap addOverlay: _movePolyLine];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.movePointAnnotation setCoordinate:lastLL];
            
        } completion:^(BOOL finished) {
            
            [_myMap addAnnotation:_movePointAnnotation];

        }];
    }
}

- (void)guijiNoAnnotation:(NSArray *)arr coordinate2DType:(Coordinate2DType)llType
{
    [_myMap removeOverlays:_myMap.overlays];
    [_myMap removeAnnotations:_myMap.annotations];
    
    NSMutableArray *guijiAnnotationArray = [NSMutableArray array];
    CLLocationCoordinate2D coors[arr.count];
    [_coordinate2DArray removeAllObjects];
    
    for (int i = 0; i < arr.count; i ++) {
        
        Model *model = arr[i];
        CLLocationCoordinate2D LL = CLLocationCoordinate2DMake(model.lat,model.lon);
        
        if (llType == Wgs84) {//坐标转换
            LL = [JZLocationConverter wgs84ToBd09:LL];
        }else if (llType == Gcj02){
            LL = [JZLocationConverter gcj02ToBd09:LL];
        }else{
            LL = LL;
        }
        
        coors[i] = LL;

        if (i == 0 || i == arr.count - 1) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:model.lat],@"lat",[NSNumber numberWithDouble:model.lon],@"lon", nil];
            [_coordinate2DArray addObject:dic];
         
            GuiJiAnnotation *annotation = [[GuiJiAnnotation alloc] init];
            [annotation setCoordinate:LL];
            [guijiAnnotationArray addObject:annotation];
        }
    }
    
    _guijiModelArray = [arr copy];
    [_myMap addAnnotations:guijiAnnotationArray];
    
    if ([self.guijiLine setPolylineWithCoordinates:coors count:arr.count]) {
        [_myMap addOverlay: _guijiLine];
        [self mapViewFitPolyLine:_guijiLine];
    }
    
    [guijiAnnotationArray removeAllObjects];
}

- (void)guijiAnnotation:(NSArray *)arr coordinate2DType:(Coordinate2DType)llType
{
    [_myMap removeOverlays:_myMap.overlays];
    [_myMap removeAnnotations:_myMap.annotations];
    [self.clusterManager clearClusterItems];
    
    [_coordinate2DArray removeAllObjects];
    [_clusterCaches removeAllObjects];
    CLLocationCoordinate2D coors[arr.count];
    
    _clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i < 22; i++) {
        [_clusterCaches addObject:[NSMutableArray array]];
    }
    
    for (int i = 0; i < arr.count; i ++) {
    
        Model *model = arr[i];
        CLLocationCoordinate2D LL = CLLocationCoordinate2DMake(model.lat,model.lon);
        
        if (llType == Wgs84) {//坐标转换
            LL = [JZLocationConverter wgs84ToBd09:LL];
        }else if (llType == Gcj02){
            LL = [JZLocationConverter gcj02ToBd09:LL];
        }else{
            LL = LL;
        }
        
        coors[i] = LL;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:model.lat],@"lat",[NSNumber numberWithDouble:model.lon],@"lon", nil];
        [_coordinate2DArray addObject:dic];
        
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        clusterItem.coor = LL;
        [self.clusterManager addClusterItem:clusterItem];
    }
    
    _guijiModelArray = [arr copy];
    [self updateClusters];
    
    if ([self.guijiLine setPolylineWithCoordinates:coors count:arr.count]) {
        [_myMap addOverlay: _guijiLine];
        [self mapViewFitPolyLine:_guijiLine];
    }
}

#pragma mark ============================== 更新聚合状态 ==============================
- (void)updateClusters {
    
    _clusterZoom = (NSInteger)_myMap.zoomLevel;
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:(_clusterZoom - 3)];
        
        if (clusters.count > 0) {
            [_myMap removeAnnotations:_myMap.annotations];
            [_myMap addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                ///获取聚合后的标注
                __block NSArray *array = [_clusterManager getClusters:_clusterZoom];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (BMKCluster *item in array) {
                        GuiJiAnnotation *annotation = [[GuiJiAnnotation alloc] init];
                        [annotation setCoordinate:item.coordinate];
                        [clusters addObject:annotation];
                    }
                    [_myMap removeAnnotations:_myMap.annotations];
                    [_myMap addAnnotations:clusters];
                });
            });
        }
    }
}


- (void)jany_cleanAllPath
{
    [_coordinate2DArray removeAllObjects];
    [_myMap removeOverlays:_myMap.overlays];
    [_myMap removeAnnotations:_myMap.annotations];
}

#pragma mark ============================== 电子围栏 ==============================
- (void)jany_drawFenceWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D coordinate2DType:(Coordinate2DType)llType centreImage:(UIImage *)centreImage radiu:(CGFloat)radiu lineColor:(UIColor *)lineColor coverColor:(UIColor *)coverColor success:(ReverseSuccess)success fail:(ReverseFail)fail
{
    if (llType == Wgs84) {//坐标转换
        coordinate2D = [JZLocationConverter wgs84ToBd09:coordinate2D];
    }else if (llType == Gcj02){
        coordinate2D = [JZLocationConverter gcj02ToBd09:coordinate2D];
    }else{
        coordinate2D = coordinate2D;
    }
    _fenceStrokerColor = lineColor;
    _fenceFillColor = coverColor;
    _fenceImage = centreImage;
    
    NSArray *objArr = _myMap.overlays;
    for (NSObject *obj in objArr) {
        
        if ([obj isKindOfClass:[BMKCircle class]]) {
            BMKCircle *fenceCircle = (BMKCircle *)obj;
            [_myMap removeOverlay:fenceCircle];
        }
    }
    
    BMKCircle *fenceCircle = [BMKCircle circleWithCenterCoordinate:coordinate2D radius:radiu];
    [_myMap addOverlay:fenceCircle];
    
    [self.fenceAnnotation setCoordinate:coordinate2D];
    [_myMap addAnnotation:_fenceAnnotation];
    [_myMap setCenterCoordinate:coordinate2D animated:YES];
    
    if (success && fail) {
        
        [self.geoCodeSearch reverseWithCoordinate2D:coordinate2D success:^(BMKReverseGeoCodeResult *result) {
            success(result.address);
        } fail:^(BMKSearchErrorCode error) {
            fail();
        }];
    }
}

@end
