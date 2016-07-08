//
//  SYAlarmCell.h
//  SmartCar
//
//  Created by Ezreal on 16/7/8.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYBaseCell.h"
#import "SYAlarm.h"

@interface SYAlarmCell : SYBaseCell

- (void)boundDataWithAlarm:(SYAlarm *)alarm;

@end
