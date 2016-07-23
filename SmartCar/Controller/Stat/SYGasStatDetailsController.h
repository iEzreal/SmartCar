//
//  SYGasStatDetailsController.h
//  SmartCar
//
//  Created by Ezreal on 16/7/13.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYBaseController.h"

@interface SYGasStatDetailsController : SYBaseController
@property(nonatomic, strong) NSString *titleStr;
@property(nonatomic, strong) NSString *gasTime;
@property(nonatomic, strong) NSString *gasAmcount;

@property(nonatomic, assign) double lat;
@property(nonatomic, assign) double lon;

@end
