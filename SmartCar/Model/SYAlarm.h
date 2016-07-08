//
//  SYAlarm.h
//  SmartCar
//
//  Created by Ezreal on 16/7/8.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYAlarm : NSObject

@property(nonatomic, strong) NSString *alarmId;
@property(nonatomic, strong) NSString *alarmStatu;
@property(nonatomic, strong) NSString *gpstime;
@property(nonatomic, strong) NSString *OBDSpeed;
@property(nonatomic, strong) NSString *OBDRpm;
@property(nonatomic, strong) NSString *OBDCoolTemp;
@property(nonatomic, strong) NSString *OBDBatt;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
