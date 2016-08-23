//
//  SYAppManager.h
//  SmartCar
//
//  Created by xxx on 16/7/5.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYUser.h"
#import "SYVehicle.h"

@interface SYAppManager : NSObject

@property(nonatomic, strong) NSString *locationStr;
@property(nonatomic, strong) SYUser *user;
@property(nonatomic, strong) SYVehicle *showVehicle;
@property(nonatomic, strong) NSMutableArray *vehicleArray;

@property(nonatomic, strong) NSString *showVehicleState; // 当前车辆状态

+ (SYAppManager *)sharedManager;

@end
