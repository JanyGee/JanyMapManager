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
    
    _flag = YES;
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
}

- (void)centerbtnclick
{
    CLLocationCoordinate2D ll = CLLocationCoordinate2DMake(22.559227896635761, 113.9482886037343);
    
    if (_flag) {
        
        _flag = NO;
        ll = CLLocationCoordinate2DMake(0, 113.9482886037346);
        
    }else{
        _flag = YES;
        ll = CLLocationCoordinate2DMake(22.559227896635761, 113.9482886037343);
    }
    
    
    [map jany_locateWithCoordinate2D:ll Coordinate2DType:Bd09 annotationImage:[UIImage imageNamed:@"sportarrow"] success:^(NSString *address) {
        NSLog(@"%@",address);
    } fail:^{
        NSLog(@"fail");
    }];
}

@end
