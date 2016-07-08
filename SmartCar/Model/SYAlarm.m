//
//  SYAlarm.m
//  SmartCar
//
//  Created by Ezreal on 16/7/8.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYAlarm.h"

@implementation SYAlarm

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (!(self = [super init])) {
        return nil;
    }
    
    _alarmId = [dic objectForKey:@"id"];
    _alarmStatu = [dic objectForKey:@"AlarmStatu"];
    _gpstime = [dic objectForKey:@"gpstime"];
    _OBDSpeed = [dic objectForKey:@"OBDSpeed"];
    _OBDRpm = [dic objectForKey:@"OBDRpm"];
    _OBDCoolTemp = [dic objectForKey:@"OBDCoolTemp"];
    _OBDBatt = [dic objectForKey:@"OBDBatt"];
    return self;
}

- (void)setDataWithDic:(NSDictionary *)dic {

}


@end
