//
//  PaopaoCustomView.m
//  Example
//
//  Created by Jany on 17/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PaopaoCustomView.h"

@interface PaopaoCustomView ()
@property (nonatomic, strong)UILabel *l;
@end
@implementation PaopaoCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.l];
    }
    return self;
}

- (UILabel *)l
{
    if (!_l) {
        _l = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 30)];
        _l.center  = self.center;
        [_l setText:@"自定义气泡上的UI"];
        [_l setAdjustsFontSizeToFitWidth:YES];
    }
    return _l;
}

- (void)setTitle:(NSString *)title
{
    [_l setText:title];
    [_l setAdjustsFontSizeToFitWidth:YES];
}

@end
