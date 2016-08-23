//
//  SYDtcCode.m
//  SmartCar
//
//  Created by xxx on 16/7/26.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
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
