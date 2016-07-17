//
//  地理围栏
//
//  SYGeofence.h
//  SmartCar
//
//  Created by Ezreal on 16/7/17.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYGeofence : NSObject

@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *rad;
@property(nonatomic, strong) NSString *lat;
@property(nonatomic, strong) NSString *lon;

@end
