//
//  UserLocation.h
//  Example
//
//  Created by Jany on 17/9/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface UserLocation : BMKLocationService
- (instancetype)initWithMap:(BMKMapView *)map;
- (void)startLocationSuccess:(void(^)(CLLocationCoordinate2D ll))starBlock fail:(void(^)(NSError *error))fail;
- (void)stopLocation;
@end
