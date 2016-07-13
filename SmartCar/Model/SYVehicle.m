//
//  SYVehicle.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYVehicle.h"

@implementation SYVehicle

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (!(self = [super init])) {
        return nil;
    }
    
    _carID = [dic objectForKey:@"CarID"];
    _carNum = [dic objectForKey:@"CarNum"];
    _termID = [dic objectForKey:@"TermID"];
    _termSN = [dic objectForKey:@"TermSN"];
    _termType = [dic objectForKey:@"TermType"];
    _tankCapacity = [dic objectForKey:@"TankCapacity"];
    _simcard = [dic objectForKey:@"simcard"];
    
    return self;
}


@end
