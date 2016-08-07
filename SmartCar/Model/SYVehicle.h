//
//  SYVehicle.h
//  SmartCar
//
//  Created by liuyiming on 16/7/5.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYVehicle : NSObject

@property(nonatomic, strong) NSString *carID;
@property(nonatomic, strong) NSString *carNum;
@property(nonatomic, strong) NSString *termID;
@property(nonatomic, strong) NSString *termSN;
@property(nonatomic, strong) NSString *termType;
@property(nonatomic, strong) NSString *tankCapacity;
@property(nonatomic, strong) NSString *simcard;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
