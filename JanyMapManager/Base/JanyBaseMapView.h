//
//  JanyBaseMapView.h
//  MapManagerDemo
//
//  Created by Jany on 17/9/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "JZLocationConverter.h"
#import "Model.h"

typedef enum : NSUInteger {//常规地图、卫星地图、3D地图
    MapNormal,
    MapSatellite,
    Map3D,
} MapDisplayType;

typedef enum : NSUInteger {
    Wgs84,//世界标准地理坐标
    Gcj02,//中国国测局地理坐标（GCJ-02）<火星坐标>
    Bd09,//百度地理坐标（BD-09)
} Coordinate2DType;

typedef void (^ReverseSuccess)(NSString *address);
typedef void (^ReverseFail)(void);

@interface JanyBaseMapView : UIView
@property (nonatomic, assign) MapDisplayType mapDispalyType;
#pragma mark ============================== 初始化 ==============================
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

#pragma mark ============================== 操作地图的一些方法 ==============================

/**
 改变地图的显示类型：常规地图、卫星地图、3D地图

 @param type MapDisplayType
 */
- (void)setMapDisplayType:(MapDisplayType)type;


/**
 定位手机用户位置

 @param success 成功刷新UI
 @param fail 失败为code=1时，是没有得到用户定位的权限
 */
- (void)startLocationSuccess:(void(^)(void))success fail:(void(^)(NSError *error))fail;
- (void)stopLocation;
#pragma mark ============================== 定位操作 ==============================
/**
 在地图上定位一个位置

 @param coordinate2D 传入的经纬度
 @param llType 经纬度类型
 */
- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType;


/**
 在地图上定位一个位置,自定义大头针样式

 @param coordinate2D 传入的经纬度
 @param llType 经纬度类型
 @param annotationImage 传入图片
 */
- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage;


/**
 在地图上定位一个位置,返回该定位点的位置信息

 @param coordinate2D 传入的经纬度
 @param llType 经纬度类型
 @param success 返回对应的dic
 @param fail 返回失败的状态
 */
- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType success:(ReverseSuccess)success fail:(ReverseFail)fail;


/**
 在地图上定位一个位置，自定义大头针样式，返回该定位点的位置信息

 @param coordinate2D 传入的经纬度
 @param llType 经纬度类型
 @param annotationImage 传入图片
 @param success 返回对应的dic
 @param fail 返回失败的状态
 */
- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage success:(ReverseSuccess)success fail:(ReverseFail)fail;


/**
 在地图上定位一个位置，自定义大头针样式,气泡上要显示的信息

 @param coordinate2D 传入的经纬度
 @param llType 经纬度类型
 @param annotationImage 传入图片
 @param infor 传入对象模型数据
 */
- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage annotationInfor:(NSObject *)infor;


/**
 在地图上定位一个位置，自定义大头针样式,气泡上要显示的信息，返回该定位点的位置信息

 @param coordinate2D 传入的经纬度
 @param llType 经纬度类型
 @param annotationImage 传入图片
 @param infor 传入对象模型数据
 @param success 返回对应的dic
 @param fail 返回失败的状态
 */
- (void)jany_locateWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D Coordinate2DType:(Coordinate2DType)llType annotationImage:(UIImage *)annotationImage annotationInfor:(NSObject *)infor success:(ReverseSuccess)success fail:(ReverseFail)fail;


#pragma mark ============================== 轨迹操作 ==============================
/*
 每次绘制点都不能过于太多，太多出现卡顿，实际中肯定会出现特殊情况，这种情况可以采取分段绘制
 */

/**
 绘制轨迹，设置起点图片和终点图片

 @param dataArr 轨迹数据，需要大于两条数据
 @param startImage 开始点图片
 @param endImage 结束点图片
 */
- (void)jany_pathMoveWithData:(NSArray *)dataArr startImage:(UIImage *)startImage endImage:(UIImage *)endImage;

/**
 绘制轨迹，设置起点图片和终点图片还有中间轨迹点的图片

 @param dataArr 轨迹数据，需要大于两条数据
 @param flag 是否显示轨迹上的大头针，yes添加
 @param width 轨迹线的宽度
 @param lineColor 轨迹的颜色
 */
- (void)jany_pathMoveWithData:(NSArray *)dataArr withAnnotation:(BOOL)flag startImage:(UIImage *)startImage middleImage:(UIImage *)img endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor;

#pragma mark ============================== 电子围栏 ==============================

/**
 画一个圆形电子围栏

 @param Coordinate2D 围栏中心
 @param radiu 范围 米
 @param lineColor 圆圈颜色
 @param coverColor 内圆颜色
 */
- (void)jany_drawFenceWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D radiu:(CGFloat)radiu lineColor:(UIColor *)lineColor coverColor:(UIColor *)coverColor;


/**
 画一个圆形电子围栏，返回中心点的地址反转信息

 @param Coordinate2D 围栏中心
 @param radiu 范围 米
 @param lineColor 圆圈颜色
 @param coverColor 内圆颜色
 @param success 返回对应的dic
 @param fail 返回失败的状态
 */
- (void)jany_drawFenceWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D radiu:(CGFloat)radiu lineColor:(UIColor *)lineColor coverColor:(UIColor *)coverColor success:(ReverseSuccess)success fail:(ReverseFail)fail;


/**
 此方法针对已经设置好了电子围栏，然后对其改变大小，调用比较频繁

 @param radiu 传入半径
 */
- (void)jany_setRadiu:(CGFloat)radiu;

@end
