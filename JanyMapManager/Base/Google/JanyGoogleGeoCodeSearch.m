//
//  JanyGoogleGeoCodeSearch.m
//  Example
//
//  Created by Jany on 17/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JanyGoogleGeoCodeSearch.h"

@implementation JanyGoogleGeoCodeSearch
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)reverseWithCoordinate2D:(CLLocationCoordinate2D)ll success:(void(^)(NSString *result))successBlock fail:(void(^)(NSError *error))failBlock
{
    GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response, NSError *error){
    
        GMSAddress *address = response.firstResult;
        if (address) {
            
            NSMutableString *snippet = [[NSMutableString alloc] init];
            if (address.subLocality != NULL) {
                [snippet appendString:address.subLocality];
            }
            if (address.locality != NULL) {
                [snippet appendString:address.locality];
            }
            if (address.administrativeArea != NULL) {
                [snippet appendString:address.administrativeArea];
            }
            if (address.country != NULL) {
                [snippet appendString:address.country];
            }
            successBlock(snippet);
        }else{
        
            failBlock(error);
        }
    };
    
    [self reverseGeocodeCoordinate:ll completionHandler:handler];
}
@end
