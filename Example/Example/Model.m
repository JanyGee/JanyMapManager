//
//  Model.m
//  Example
//
//  Created by Jany on 17/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "Model.h"

@implementation Model
- (void)setType:(NSInteger)type
{
    _type = arc4random() % 3;
}
@end
