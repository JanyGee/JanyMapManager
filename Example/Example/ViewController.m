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
    JanyBaseMapView *map;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    map = [[JanyBaiduMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:map];
    [map setMapDispalyType:Map3D];
    
    [self setUI];
}

#pragma mark ============================== setupUI ==============================
- (void)setUI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.f, 0.f, 50.f, 50.f)];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [map addSubview:btn];
    
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}


- (void)click{
    
    [map setMapDispalyType:MapNormal];
}
@end
