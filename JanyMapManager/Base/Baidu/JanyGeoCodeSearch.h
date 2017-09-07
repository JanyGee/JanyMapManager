//
//  JanyGeoCodeSearch.h
//  Example
//
//  Created by Jany on 17/9/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface JanyGeoCodeSearch : BMKGeoCodeSearch
- (void)reverseWithCoordinate2D:(CLLocationCoordinate2D)ll success:(void(^)(BMKReverseGeoCodeResult *result))successBlock fail:(void(^)(BMKSearchErrorCode error))failBlock;
@end
