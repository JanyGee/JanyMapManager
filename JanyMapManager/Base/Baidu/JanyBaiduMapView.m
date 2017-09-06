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
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@interface JanyBaiduMapView ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic, strong)BMKMapView *myMap;
@end

@implementation JanyBaiduMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.myMap];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:self.myMap];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withMapDisplayType:(MapDisplayType)type
{
    self = [super initWithFrame:frame withMapDisplayType:type];
    if (self) {
        [self addSubview:self.myMap];
    }
    return self;
}

#pragma mark ============================== setupUI ==============================
- (BMKMapView *)myMap
{
    if (!_myMap) {
        
        _myMap = [[BMKMapView alloc]initWithFrame:self.bounds];
        [_myMap setMapType:BMKMapTypeStandard];
        [_myMap setZoomLevel:15.f];
        [_myMap setDelegate:self];
        
    }
    
    return _myMap;
}
@end
