//
//  Model.h
//  Example
//
//  Created by Jany on 17/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)double lat;
@property (nonatomic, assign)double lon;
@property (nonatomic, copy)NSString *title;
@end
