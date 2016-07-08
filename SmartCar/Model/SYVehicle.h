//
//  SYVehicle.h
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYVehicle : NSObject

@property(nonatomic, strong) NSString *carID;
@property(nonatomic, strong) NSString *carNum;
@property(nonatomic, strong) NSString *termID;
@property(nonatomic, strong) NSString *termSN;
@property(nonatomic, strong) NSString *termType;
@property(nonatomic, strong) NSString *simcard;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
