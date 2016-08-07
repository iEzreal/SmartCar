//
//  SYTravel.h
//  SmartCar
//
//  Created by liuyiming on 16/7/6.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYTravel : NSObject

@property(nonatomic, strong) NSString *traId;
@property(nonatomic, strong) NSString *carId;
@property(nonatomic, strong) NSString *termId;
@property(nonatomic, strong) NSString *recvTime;
@property(nonatomic, strong) NSString *tripTime;
@property(nonatomic, strong) NSString *lon;
@property(nonatomic, strong) NSString *lat;
@property(nonatomic, strong) NSString *tripCount;
@property(nonatomic, strong) NSString *engineOnOff;
@property(nonatomic, strong) NSString *OBDTolMileage;

@property(nonatomic, strong) NSString *id_E;
@property(nonatomic, strong) NSString *cardID_E;
@property(nonatomic, strong) NSString *termID_E;
@property(nonatomic, strong) NSString *recvTime_E;
@property(nonatomic, strong) NSString *tripTime_E;
@property(nonatomic, strong) NSString *lon_E;
@property(nonatomic, strong) NSString *lat_E;
@property(nonatomic, strong) NSString *tripCount_E;
@property(nonatomic, strong) NSString *engineOnOff_2;
@property(nonatomic, strong) NSString *OBDTolMileage_E;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
