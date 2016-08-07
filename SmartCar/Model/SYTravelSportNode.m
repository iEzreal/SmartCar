//
//  SYTravelSportNode.m
//  SmartCar
//
//  Created by liuyiming on 16/7/7.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYTravelSportNode.h"

@implementation SYTravelSportNode

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (!(self = [super init])) {
        return nil;
    }
    
    _nodeId = [dic objectForKey:@"id"];
    _carID = [dic objectForKey:@"CarID"];
    _termID = [dic objectForKey:@"TermID"];
    _recvTime = [dic objectForKey:@"RecvTime"];
    _gpstime = [dic objectForKey:@"gpstime"];
    _lat = [dic objectForKey:@"lat"];
    _lon = [dic objectForKey:@"lon"];
    _direction = [dic objectForKey:@"Direction"];
    _speed = [dic objectForKey:@"Speed"];
    _acceleration = [dic objectForKey:@"Acceleration"];
    
    return self;
}

@end
