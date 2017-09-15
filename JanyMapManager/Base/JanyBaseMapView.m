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

- (void)startLocationSuccess:(void(^)(void))success fail:(void(^)(NSError *error))fail
{

}

- (void)stopLocation
{

}

- (void)setMapDisplayType:(MapDisplayType)type
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType success:(ReverseSuccess)success fail:(ReverseFail)fail
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage success:(ReverseSuccess)success fail:(ReverseFail)fail
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage annotationInfor:(NSObject *)infor
{

}

- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage annotationInfor:(NSObject *)infor success:(ReverseSuccess)success fail:(ReverseFail)fail
{

}

- (void)jany_locateWithCoordinate2Ds:(NSArray *)inforArray annotationImage:(UIImage *)annotationImage
{

}

- (void)jany_locateWithCoordinate2Ds:(NSArray *)inforArray annotationImages:(NSArray *)annotationImages
{

}
#pragma mark ============================== 轨迹操作 ==============================
- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage endImage:(UIImage *)endImage
{

}
- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage middleImage:(UIImage *)img endImage:(UIImage *)endImage
{

}

- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage wifiImgae:(UIImage *)wifiImgae gpsImage:(UIImage *)gpsImage lbsImage:(UIImage *)lbsImage endImage:(UIImage *)endImage
{

}

- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage middleImage:(UIImage *)img endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor
{

}

- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage wifiImgae:(UIImage *)wifiImgae gpsImage:(UIImage *)gpsImage lbsImage:(UIImage *)lbsImage endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor
{

}

- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType moveImage:(UIImage *)moveImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor
{

}

- (void)jany_imagePathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage middleImage:(UIImage *)img endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineImage:(UIImage *)lineImage
{

}

- (void)jany_imagePathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage wifiImgae:(UIImage *)wifiImgae gpsImage:(UIImage *)gpsImage lbsImage:(UIImage *)lbsImage endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineImage:(UIImage *)lineImage
{

}

- (void)jany_cleanAllPath
{

}

#pragma mark ============================== 电子围栏 ==============================
- (void)jany_drawFenceWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D coordinate2DType:(Coordinate2DType)llType centreImage:(UIImage *)centreImage radiu:(CGFloat)radiu lineColor:(UIColor *)lineColor coverColor:(UIColor *)coverColor
{

}
- (void)jany_drawFenceWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D coordinate2DType:(Coordinate2DType)llType centreImage:(UIImage *)centreImage radiu:(CGFloat)radiu lineColor:(UIColor *)lineColor coverColor:(UIColor *)coverColor success:(ReverseSuccess)success fail:(ReverseFail)fail
{

}

- (void)jany_drawFenceWithCoordinate2D:(NSArray *)fenceArrary coordinate2DType:(Coordinate2DType)llType images:(NSArray *)imageArrary
{

}

- (void)jany_setRadiu:(CGFloat)radiu
{

}

- (void)jany_cleanAllFence
{

}
@end
