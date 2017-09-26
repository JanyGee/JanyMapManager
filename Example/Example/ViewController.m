//
//  ViewController.m
//  Example
//
//  Created by Jany on 17/9/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "JanyBaseMapView.h"
#import "JanyBaiduMapView.h"
#import "Model.h"

@interface ViewController ()
{
    BOOL _flag;
    JanyBaseMapView *map;
    UIButton *btn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _flag = NO;
    map = [[JanyBaiduMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:map];
    [map startLocationSuccess:^{
        
        [map stopLocation];
        
    } fail:^(NSError *error) {
        [btn setBackgroundColor:[UIColor redColor]];
        if (error.code == 1) {
            NSLog(@"没有得到用户定位授权");
        }
    }];
    
    [self setUI];
    
}

#pragma mark ============================== setupUI ==============================
- (void)setUI
{
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.f, 0.f, 50.f, 50.f)];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [map addSubview:btn];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *centerbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerbtn setFrame:CGRectMake(80.f, 0.f, 50.f, 50.f)];
    [centerbtn setBackgroundColor:[UIColor greenColor]];
    [map addSubview:centerbtn];
    [centerbtn addTarget:self action:@selector(centerbtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setFrame:CGRectMake(160.f, 0.f, 50.f, 50.f)];
    [btn3 setBackgroundColor:[UIColor lightGrayColor]];
    [btn3 setTitle:@"清除" forState:UIControlStateNormal];
    [map addSubview:btn3];
    [btn3 addTarget:self action:@selector(btn3Click) forControlEvents:UIControlEventTouchUpInside];
    
    UISlider *slide = [[UISlider alloc] initWithFrame:CGRectMake(40.f, 80.f, 300.f, 50.f)];
    [slide setMinimumValue:0];
    [slide setMaximumValue:1];
    [map addSubview:slide];
    
    [slide addTarget:self action:@selector(slideChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)slideChange:(UISlider *)slide
{

    CLLocationCoordinate2D coors[12];
    coors[0] = CLLocationCoordinate2DMake(22.559227896635761, 113.9482886037343);
    coors[1] = CLLocationCoordinate2DMake(22.571082523507, 113.90489842423);
    coors[2] = CLLocationCoordinate2DMake(22.571030147266, 113.90458044929);
    coors[3] = CLLocationCoordinate2DMake(22.571076901093, 113.90400776584);
    coors[4] = CLLocationCoordinate2DMake(22.571090775253, 113.90383739502);
    coors[5] = CLLocationCoordinate2DMake(22.571269494089, 113.90343044001);
    coors[6] = CLLocationCoordinate2DMake(22.571270547492, 113.90335423128);
    coors[7] = CLLocationCoordinate2DMake(22.57135417857, 113.90323699237);
    coors[8] = CLLocationCoordinate2DMake(22.571785734488, 113.90283532769);
    coors[9] = CLLocationCoordinate2DMake(22.571845558947, 113.90262582616);
    coors[10] = CLLocationCoordinate2DMake(22.573396860615, 113.90112740338);
    coors[11] = CLLocationCoordinate2DMake(22.57440620437, 113.90014707411);
    
    int count = 12 * slide.value;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:12];
    for (int i = 0; i < count; i ++) {
        
        Model *model = [[Model alloc] init];
        model.lat = coors[i].latitude;
        model.lon = coors[i].longitude;
        model.title = [NSString stringWithFormat:@"%d",i];
        
        [arr addObject:model];
    }
    
    //[map jany_pathMoveWithData:arr startImage:[UIImage imageNamed:@"startPoint"] middleImage:nil endImage:[UIImage imageNamed:@"endPoint"]];
    [map jany_pathMoveWithData:arr coordinate2DType:Bd09 moveImage:[UIImage imageNamed:@"HomePage_anchorBackground"] lineWidth:3 lineColor:[UIColor greenColor]];
}

- (void)click{
    
//    [map setMapDispalyType:Map3D];
    
    if (_flag) {
        
        _flag = NO;
        [map startLocationSuccess:^{
            [btn setBackgroundColor:[UIColor lightGrayColor]];
        } fail:^(NSError *error) {
            [btn setBackgroundColor:[UIColor redColor]];
            if (error.code == 1) {
                NSLog(@"没有得到用户定位授权");
            }
        }];
        
    }else{
        _flag = YES;
        [map stopLocation];
    }
    
    [map jany_cleanAllPath];
}

- (void)centerbtnclick
{
    
//    CLLocationCoordinate2D ll = CLLocationCoordinate2DMake(22.559227896635761, 113.9482886037343);
//    
//    if (_flag) {
//        
//        _flag = NO;
//        ll = CLLocationCoordinate2DMake(22.55922789663576, 113.9482886037346);
//        
//    }else{
//        _flag = YES;
//        ll = CLLocationCoordinate2DMake(22.559227896635761, 113.9482886037343);
//    }
//    
//    [map jany_locateWithCoordinate2D:ll Coordinate2DType:Bd09 annotationImage:[UIImage imageNamed:@"homePage_wholeAnchor"] success:^(NSString *address) {
//        NSLog(@"%@",address);
//    } fail:^{
//        NSLog(@"fail");
//    }];
    

    if (_flag) {
        
        _flag = NO;
//        CLLocationCoordinate2D coors[12];
//        coors[0] = CLLocationCoordinate2DMake(22.559227896635761, 113.9482886037343);
//        coors[1] = CLLocationCoordinate2DMake(22.571082523507, 113.90489842423);
//        coors[2] = CLLocationCoordinate2DMake(22.571030147266, 113.90458044929);
//        coors[3] = CLLocationCoordinate2DMake(22.571076901093, 113.90400776584);
//        coors[4] = CLLocationCoordinate2DMake(22.571090775253, 113.90383739502);
//        coors[5] = CLLocationCoordinate2DMake(22.571269494089, 113.90343044001);
//        coors[6] = CLLocationCoordinate2DMake(22.571270547492, 113.90335423128);
//        coors[7] = CLLocationCoordinate2DMake(22.57135417857, 113.90323699237);
//        coors[8] = CLLocationCoordinate2DMake(22.571785734488, 113.90283532769);
//        coors[9] = CLLocationCoordinate2DMake(22.571845558947, 113.90262582616);
//        coors[10] = CLLocationCoordinate2DMake(22.573396860615, 113.90112740338);
//        coors[11] = CLLocationCoordinate2DMake(22.57440620437, 113.90014707411);
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(22.559227896635761, 113.9482886037343);
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:12];
            for (int i = 0; i < 100; i ++) {
                double lat =  (arc4random() % 100) * 0.001f;
                double lon =  (arc4random() % 100) * 0.001f;
                Model *model = [[Model alloc] init];
                model.lat = coor.latitude + lat;
                model.lon = coor.longitude + lon;
                model.title = [NSString stringWithFormat:@"%d",i];
                
                [arr addObject:model];
            }
            
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                [map jany_pathMoveWithData:arr coordinate2DType:Bd09 startImage:[UIImage imageNamed:@"startPoint"] wifiImgae:[UIImage imageNamed:@"HomePage_anchorBackground"] gpsImage:[UIImage imageNamed:@"homePage_wholeAnchor"] lbsImage:[UIImage imageNamed:@"startAnnoImage"] endImage:[UIImage imageNamed:@"endPoint"] lineWidth:2 lineColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
                
                //        [map jany_pathMoveWithData:arr coordinate2DType:Bd09 startImage:[UIImage imageNamed:@"startPoint"] middleImage:nil endImage:[UIImage imageNamed:@"endPoint"] lineWidth:2 lineColor:[[UIColor greenColor] colorWithAlphaComponent:0.5]];
                
                
                
                //        [map jany_pathMoveWithData:arr startImage:[UIImage imageNamed:@"startPoint"] wifiImgae:[UIImage imageNamed:@"HomePage_anchorBackground"] gpsImage:[UIImage imageNamed:@"homePage_wholeAnchor"] lbsImage:[UIImage imageNamed:@"startAnnoImage"] endImage:[UIImage imageNamed:@"endPoint"] lineWidth:2 lineColor:[UIColor greenColor]];
                
//            });
//        });

        
        
    }else{

        _flag = YES;
        
        CLLocationCoordinate2D coors[12];
        coors[0] = CLLocationCoordinate2DMake(22.922789663576, 113.9482886037343);
        coors[1] = CLLocationCoordinate2DMake(22.8108252350, 113.90489842423);
        coors[2] = CLLocationCoordinate2DMake(22.7103014726, 113.90458044929);
        coors[3] = CLLocationCoordinate2DMake(22.7107690193, 113.90400776584);
        coors[4] = CLLocationCoordinate2DMake(22.57109077253, 113.90383739502);
        coors[5] = CLLocationCoordinate2DMake(22.57126944089, 113.90343044001);
        coors[6] = CLLocationCoordinate2DMake(22.57127047492, 113.90335423128);
        coors[7] = CLLocationCoordinate2DMake(22.5713517857, 113.90323699237);
        coors[8] = CLLocationCoordinate2DMake(22.57175734488, 113.90283532769);
        coors[9] = CLLocationCoordinate2DMake(22.57145558947, 113.90262582616);
        coors[10] = CLLocationCoordinate2DMake(22.53396860615, 113.90112740338);
        coors[11] = CLLocationCoordinate2DMake(22.7440620437, 113.90014707411);
        
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:12];
        for (int i = 0; i < 12; i ++) {
            
            Model *model = [[Model alloc] init];
            model.lat = coors[i].latitude;
            model.lon = coors[i].longitude;
            model.title = [NSString stringWithFormat:@"%d",i];
            
            [arr addObject:model];
        }
        
//        [map jany_pathMoveWithData:arr startImage:[UIImage imageNamed:@"startPoint"] middleImage:nil endImage:[UIImage imageNamed:@"endPoint"]];
        [map jany_imagePathMoveWithData:arr coordinate2DType:Bd09 startImage:[UIImage imageNamed:@"startPoint"] middleImage:nil endImage:[UIImage imageNamed:@"endPoint"] lineWidth:4 lineImage:[UIImage imageNamed:@"arrowTexture"]];
//        [map jany_pathMoveWithData:arr coordinate2DType:Bd09 startImage:[UIImage imageNamed:@"startPoint"] wifiImgae:[UIImage imageNamed:@"HomePage_anchorBackground"] gpsImage:[UIImage imageNamed:@"homePage_wholeAnchor"] lbsImage:[UIImage imageNamed:@"startAnnoImage"] endImage:[UIImage imageNamed:@"endPoint"] lineWidth:2 lineColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
    }

}

- (void)btn3Click
{
    //[map jany_cleanAllPath];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(22.559227896635761, 113.9482886037343);
    [map jany_drawFenceWithCoordinate2D:coor coordinate2DType:Bd09 centreImage:[UIImage imageNamed:@"HomePage_anchorBackground"] radiu:3000 lineColor:[UIColor greenColor] coverColor:[[UIColor blueColor] colorWithAlphaComponent:0.3] success:^(NSString *address) {
        NSLog(@"%@",address);
    } fail:^{
        
    }];
}

@end
