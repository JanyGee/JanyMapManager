//
//  JanyGeoCodeSearch.m
//  Example
//
//  Created by Jany on 17/9/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JanyGeoCodeSearch.h"

@interface JanyGeoCodeSearch ()<BMKGeoCodeSearchDelegate>
{
    void(^_success)(BMKReverseGeoCodeResult *address);
    void(^_fail)(BMKSearchErrorCode error);
}
@property (nonatomic, strong)BMKReverseGeoCodeOption *reverseGeocodeSearchOption;

@end
@implementation JanyGeoCodeSearch
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDelegate:self];
    }
    return self;
}

- (BMKReverseGeoCodeOption *)reverseGeocodeSearchOption
{
    if (!_reverseGeocodeSearchOption) {
        _reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    }
    
    return _reverseGeocodeSearchOption;
}
#pragma mark ============================== delegate ==============================
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR){
        _success(result);
    }else{
        _fail(error);
    }
}

- (void)reverseWithCoordinate2D:(CLLocationCoordinate2D)ll success:(void(^)(BMKReverseGeoCodeResult *address))successBlock fail:(void(^)(BMKSearchErrorCode error))failBlock
{
    _success = successBlock;
    _fail = failBlock;
    
    self.reverseGeocodeSearchOption.reverseGeoPoint = ll;
    [self reverseGeoCode:_reverseGeocodeSearchOption];
}
@end
