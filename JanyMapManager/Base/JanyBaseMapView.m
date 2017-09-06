//
//  JanyBaseMapView.m
//  MapManagerDemo
//
//  Created by Jany on 17/9/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JanyBaseMapView.h"

@implementation JanyBaseMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withMapDisplayType:(MapDisplayType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setMapDisplayType:(MapDisplayType)type
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D annotationImage:(UIImage *)annotationImage
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D success:(ReverseSuccess)success fail:(ReverseFail)fail
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D annotationImage:(UIImage *)annotationImage success:(ReverseSuccess)success fail:(ReverseFail)fail
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D annotationImage:(UIImage *)annotationImage annotationInfor:(NSObject *)infor
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D annotationImage:(UIImage *)annotationImage annotationInfor:(NSObject *)infor success:(ReverseSuccess)success fail:(ReverseFail)fail
{

}

- (void)jany_pathMoveWithData:(NSArray *)dataArr
{

}

- (void)jany_pathMoveWithData:(NSArray *)dataArr lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor
{

}

- (void)jany_drawFenceWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D radiu:(CGFloat)radiu lineColor:(UIColor *)lineColor coverColor:(UIColor *)coverColor
{

}
- (void)jany_drawFenceWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D radiu:(CGFloat)radiu lineColor:(UIColor *)lineColor coverColor:(UIColor *)coverColor success:(ReverseSuccess)success fail:(ReverseFail)fail
{

}
- (void)jany_setRadiu:(CGFloat)radiu
{

}
@end
