//
//  地理围栏
//
//  SYGeofence.h
//  SmartCar
//
//  Created by liuyiming on 16/7/17.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYGeofence : NSObject

@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *rad;
@property(nonatomic, strong) NSString *lat;
@property(nonatomic, strong) NSString *lon;

@end
