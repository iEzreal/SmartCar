//
//  SYAppManager.h
//  SmartCar
//
//  Created by liuyiming on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYUser.h"
#import "SYVehicle.h"

@interface SYAppManager : NSObject

@property(nonatomic, strong) NSString *locationStr;
@property(nonatomic, strong) SYUser *user;
@property(nonatomic, strong) SYVehicle *showVehicle;
@property(nonatomic, strong) NSMutableArray *vehicleArray;

+ (SYAppManager *)sharedManager;

@end
