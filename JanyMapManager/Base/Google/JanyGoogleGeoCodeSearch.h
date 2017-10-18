//
//  JanyGoogleGeoCodeSearch.h
//  Example
//
//  Created by Jany on 17/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface JanyGoogleGeoCodeSearch : GMSGeocoder

- (void)reverseWithCoordinate2D:(CLLocationCoordinate2D)ll success:(void(^)(NSString *result))successBlock fail:(void(^)(NSError *error))failBloc;
@end
