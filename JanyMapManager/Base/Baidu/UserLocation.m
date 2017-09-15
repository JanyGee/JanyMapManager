//
//  UserLocation.m
//  Example
//
//  Created by Jany on 17/9/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UserLocation.h"

@interface UserLocation ()<BMKLocationServiceDelegate>
{
    BMKMapView *_myMap;
    void (^_starLocateSuccessBlock)(CLLocationCoordinate2D ll);
    void (^_locateFailBlock)(NSError *error);
}
@property (nonatomic, strong)BMKLocationViewDisplayParam *param;
@end

@implementation UserLocation
- (instancetype)initWithMap:(BMKMapView *)map
{
    self = [super init];
    if (self) {
        _myMap = map;
    }
    
    return self;
}

- (void)startLocationSuccess:(void (^)(CLLocationCoordinate2D))starBlock fail:(void (^)(NSError *))fail
{
    _starLocateSuccessBlock = starBlock;
    _locateFailBlock = fail;
    [self setDelegate:self];
    [self startUserLocationService];
    [_myMap setShowsUserLocation:NO];//先关闭显示的定位图层
    [_myMap setUserTrackingMode:BMKUserTrackingModeNone];//设置定位的状态
    [_myMap setShowsUserLocation:YES];//显示定位图层
    [_myMap updateLocationViewWithParam:self.param];
    
}

- (void)stopLocation
{
    [self stopUserLocationService];
    [_myMap setShowsUserLocation:NO];
    [self setDelegate:nil];
}

- (BMKLocationViewDisplayParam *)param
{
    if (!_param) {
        _param = [[BMKLocationViewDisplayParam alloc] init];
        _param.locationViewImgName = @"homePage_wholeAnchor";
        _param.isRotateAngleValid = YES;
        _param.isAccuracyCircleShow = NO;
    }
    
    return _param;
}

#pragma mark ============================== delegate ==============================
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (_starLocateSuccessBlock) {
        _starLocateSuccessBlock(CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude));
    }
    
    [_myMap updateLocationData:userLocation];
    [self stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    if (_locateFailBlock) {
        _locateFailBlock(error);
    }
}
@end
