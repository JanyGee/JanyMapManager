# JanyMapManager
三种地图的封装，方便项目开发使用
百度
1.可以设置用户点位的图片
定位图标名称，需要将该图片放到 mapapi.bundle/images 目录下
@property (nonatomic, strong) NSString* locationViewImgName;

2.绘制圆形电子围栏的时候，注意填充色
注：请使用 - (UIColor *)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha; 初始化UIColor，使用[UIColor ***Color]初始化时，个别case转换成RGB后会有问题
