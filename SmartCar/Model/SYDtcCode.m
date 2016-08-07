//
//  SYDtcCode.m
//  SmartCar
//
//  Created by liuyiming on 16/7/26.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYDtcCode.h"

@implementation SYDtcCode

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (!(self = [super init])) {
        return nil;
    }
    
    _dtcCode = [dic objectForKey:@"DTC_Code"];
    _explain = [dic objectForKey:@"Explain"];
    return self;
}


@end
