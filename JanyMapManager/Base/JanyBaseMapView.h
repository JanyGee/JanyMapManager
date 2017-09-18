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
#import <objc/runtime.h>

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

/**
 多点定位显示

 @param inforArray 带经纬度的模型数组
 @param annotationImage 定位点大头针
 */
- (void)jany_locateWithCoordinate2Ds:(NSArray *)inforArray annotationImage:(UIImage *)annotationImage;


/**
 多点定位显示，每一个点的大头针图片不同

 @param inforArray 带经纬度的模型数组
 @param annotationImages 针对model的annotation图片
 */
- (void)jany_locateWithCoordinate2Ds:(NSArray *)inforArray annotationImages:(NSArray *)annotationImages;
#pragma mark ============================== 轨迹操作 ==============================
/*
 每次绘制点都不能过于太多，太多出现卡顿，实际中肯定会出现特殊情况，这种情况可以采取分段绘制
 */

/**
  绘制轨迹，设置起点图片，终点图片

 @param dataArr 数据模型数组
 @param startImage 开始点的图片
 @param endImage 结束点的图片
 */
- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage endImage:(UIImage *)endImage;

/**
 绘制轨迹，设置起点图片，中间点的图片，终点图片

 @param dataArr 轨迹数据，需要大于两条数据
 @param startImage 开始点图片
 @param img 中间轨迹点的图片
 @param endImage 结束点图片
 */
- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage middleImage:(UIImage *)img endImage:(UIImage *)endImage;

/**
 绘制轨迹，设置起点，中间不同定类型点的图片（wifi，GPS，lbs）三种类型，终点图片

 @param dataArr 轨迹数据，需要大于两条数据
 @param startImage 开始点图片
 @param wifiImgae wifi点的图片
 @param gpsImage gps点的图片
 @param lbsImage lbs点的图片
 @param endImage 结束点的图片
 */
- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage wifiImgae:(UIImage *)wifiImgae gpsImage:(UIImage *)gpsImage lbsImage:(UIImage *)lbsImage endImage:(UIImage *)endImage;
/**
 绘制轨迹，设置起点图片和终点图片还有中间轨迹点的图片

 @param dataArr 轨迹数据，需要大于两条数据
 @param startImage 开始点图片
 @param img 中间轨迹点的图片
 @param endImage 结束点图片
 @param width 轨迹线的宽度
 @param lineColor 轨迹的颜色
 */
- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage middleImage:(UIImage *)img endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor;


/**
 绘制轨迹，设置起点，中间不同定类型点的图片（wifi，GPS，lbs）三种类型，终点图片,设置轨迹线的颜色和宽度

 @param dataArr 轨迹数据，需要大于两条数据
 @param startImage 开始点图片
 @param wifiImgae wifi点的图片
 @param gpsImage gps点的图片
 @param lbsImage lbs点的图片
 @param endImage 结束点的图片
 @param width 轨迹线的宽度
 @param lineColor 轨迹的颜色
 */
- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage wifiImgae:(UIImage *)wifiImgae gpsImage:(UIImage *)gpsImage lbsImage:(UIImage *)lbsImage endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor;

/**
 绘制轨迹，设置起点图片和终点图片还有中间轨迹点的图片
 
 @param dataArr 轨迹数据，需要大于两条数据
 @param startImage 开始点图片
 @param img 中间轨迹点的图片
 @param endImage 结束点图片
 @param width 轨迹线的宽度
 @param lineImage 图片
 */
- (void)jany_imagePathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage middleImage:(UIImage *)img endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineImage:(UIImage *)lineImage;

/**
 绘制带图片的轨迹，设置起点，中间不同定类型点的图片（wifi，GPS，lbs）三种类型，终点图片,设置轨迹线的颜色和宽度
 
 @param dataArr 轨迹数据，需要大于两条数据
 @param startImage 开始点图片
 @param wifiImgae wifi点的图片
 @param gpsImage gps点的图片
 @param lbsImage lbs点的图片
 @param endImage 结束点的图片
 @param width 轨迹线的宽度
 @param lineImage 轨迹的颜色
 */
- (void)jany_imagePathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType startImage:(UIImage *)startImage wifiImgae:(UIImage *)wifiImgae gpsImage:(UIImage *)gpsImage lbsImage:(UIImage *)lbsImage endImage:(UIImage *)endImage lineWidth:(CGFloat)width lineImage:(UIImage *)lineImage;

/**
 类似贪食蛇的轨迹画法，针对新app的需求

 @param dataArr 变化的数据，slider来控制
 @param moveImage 蛇头图片
 @param width 轨迹线的宽度
 @param lineColor 轨迹的颜色
 */
- (void)jany_pathMoveWithData:(NSArray *)dataArr coordinate2DType:(Coordinate2DType)llType moveImage:(UIImage *)moveImage lineWidth:(CGFloat)width lineColor:(UIColor *)lineColor;


/**
 清除轨迹信息
 */
- (void)jany_cleanAllPath;
#pragma mark ============================== 电子围栏 ==============================

/**
 画一个圆形电子围栏

 @param coordinate2D 围栏中心
 @param centreImage 圆中心点的图片
 @param radiu 范围 米
 @param lineColor 圆圈颜色
 @param coverColor 内圆颜色
 */
- (void)jany_drawFenceWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D coordinate2DType:(Coordinate2DType)llType centreImage:(UIImage *)centreImage radiu:(CGFloat)radiu lineColor:(UIColor *)lineColor coverColor:(UIColor *)coverColor;

/**
 画一个圆形电子围栏，返回中心点的地址反转信息，填充色（百度地图要求）

 @param coordinate2D 围栏中心
 @param centreImage 圆中心点的图片
 @param radiu 范围 米
 @param lineColor 圆圈颜色
 @param coverColor 内圆颜色
 @param success 返回对应的dic
 @param fail 返回失败的状态
 */
- (void)jany_drawFenceWithCoordinate2D:(CLLocationCoordinate2D)coordinate2D coordinate2DType:(Coordinate2DType)llType centreImage:(UIImage *)centreImage radiu:(CGFloat)radiu lineColor:(UIColor *)lineColor coverColor:(UIColor *)coverColor success:(ReverseSuccess)success fail:(ReverseFail)fail;


/**
 画多个电子围栏

 @param fenceArrary 电子围栏模型数组
 @param imageArrary 按排列的图片名，针对模型里面的数据
 */
- (void)jany_drawFenceWithCoordinate2D:(NSArray *)fenceArrary coordinate2DType:(Coordinate2DType)llType images:(NSArray *)imageArrary;

/**
 此方法针对已经设置好了电子围栏，然后对其改变大小，调用比较频繁

 @param radiu 传入半径
 */
- (void)jany_setRadiu:(CGFloat)radiu;

/**
 清除所有电子围栏信息
 */
- (void)jany_cleanAllFence;
@end
