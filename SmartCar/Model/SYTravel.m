//
//  SYTravel.m
//  SmartCar
//
//  Created by xxx on 16/7/6.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYTravel.h"

@implementation SYTravel

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (!(self = [super init])) {
        return nil;
    }
    
    _traId = [dic objectForKey:@"ID"];
    _carId = [dic objectForKey:@"CarID"];
    _termId = [dic objectForKey:@"TermID"];
    _recvTime = [dic objectForKey:@"RecvTime"];
    _tripTime = [dic objectForKey:@"TripTime"];
    _lon = [dic objectForKey:@"lon"];
    _lat = [dic objectForKey:@"lat"];
    _tripCount = [dic objectForKey:@"TripCount"];
    _engineOnOff = [dic objectForKey:@"EngineOnOff"];
    _OBDTolMileage = [dic objectForKey:@"OBDTolMileage"];
    
    _id_E = [dic objectForKey:@"ID_E"];
    _cardID_E = [dic objectForKey:@"CardID_E"];
    _termID_E = [dic objectForKey:@"TermID_E"];
    _recvTime_E = [dic objectForKey:@"RecvTime_E"];
    _tripTime_E = [dic objectForKey:@"TripTime_E"];
    _lon_E = [dic objectForKey:@"lon_E"];
    _lat_E = [dic objectForKey:@"lat_E"];
    _tripCount_E = [dic objectForKey:@"TripCount_E"];
    _engineOnOff_2 = [dic objectForKey:@"EngineOnOff_2"];
    _OBDTolMileage_E = [dic objectForKey:@"OBDTolMileage_E"];

    return self;
}

@end
