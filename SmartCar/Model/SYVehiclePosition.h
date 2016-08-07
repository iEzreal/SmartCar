//
//  SYVehiclePosition.h
//  SmartCar
//
//  Created by liuyiming on 16/7/6.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYVehiclePosition : NSObject

@property(nonatomic, strong) NSString *recvTime; //
@property(nonatomic, strong) NSString *engineOnOff; // 车辆行驶状态  =0 停止状态 =其他行驶状态
@property(nonatomic, strong) NSString *OBDGasLevel; // 油压百分比
@property(nonatomic, strong) NSString *OBDSpeed; // 车速
@property(nonatomic, strong) NSString *OBDBatt; // 电池电压
@property(nonatomic, strong) NSString *mileage; // 累计行驶里程
@property(nonatomic, strong) NSString *lon;
@property(nonatomic, strong) NSString *lat;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
