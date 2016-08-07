//
//  SYVehiclePosition.m
//  SmartCar
//
//  Created by liuyiming on 16/7/6.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYVehiclePosition.h"

@implementation SYVehiclePosition

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (!(self = [super init])) {
        return nil;
    }
    
    _recvTime = [dic objectForKey:@"RecvTime"];
    _engineOnOff = [dic objectForKey:@"EngineOnOff"];
    _OBDGasLevel = [dic objectForKey:@"OBDGasLevel"];
    _OBDSpeed = [dic objectForKey:@"OBDSpeed"];
    _OBDBatt = [dic objectForKey:@"OBDBatt"];
    _mileage = [dic objectForKey:@"Mileage"];
    _lon = [dic objectForKey:@"lon"];
    _lat = [dic objectForKey:@"lat"];
    return self;
}


@end
