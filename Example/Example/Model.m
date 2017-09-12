//
//  Model.m
//  Example
//
//  Created by Jany on 17/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "Model.h"

@implementation Model
- (NSInteger)type
{
    return arc4random() % 3;
}
@end
