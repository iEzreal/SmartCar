//
//  SYGasStatDetailsController.h
//  SmartCar
//
//  Created by liuyiming on 16/7/13.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYBaseController.h"

@interface SYGasStatDetailsController : SYBaseController
@property(nonatomic, strong) NSString *titleStr;
@property(nonatomic, strong) NSString *gasTime;
@property(nonatomic, strong) NSString *gasAmcount;

@property(nonatomic, assign) double lat;
@property(nonatomic, assign) double lon;

@end
