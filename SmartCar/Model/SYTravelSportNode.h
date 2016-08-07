//
//  SYTravelSportNode.h
//  SmartCar
//
//  Created by liuyiming on 16/7/7.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYTravelSportNode : NSObject

@property(nonatomic, strong) NSString *nodeId;
@property(nonatomic, strong) NSString *carID;
@property(nonatomic, strong) NSString *termID;
@property(nonatomic, strong) NSString *recvTime;
@property(nonatomic, strong) NSString *gpstime;
@property(nonatomic, strong) NSString *lat;
@property(nonatomic, strong) NSString *lon;
@property(nonatomic, strong) NSString *direction;
@property(nonatomic, strong) NSString *speed;
@property(nonatomic, strong) NSString *acceleration;

- (instancetype)initWithDic:(NSDictionary *)dic;


@end
