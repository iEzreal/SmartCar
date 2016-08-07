//
//  SYAlarmCell.h
//  SmartCar
//
//  Created by liuyiming on 16/7/8.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYBaseCell.h"
#import "SYAlarm.h"

@interface SYAlarmCell : SYBaseCell

- (void)boundDataWithAlarm:(SYAlarm *)alarm;

@end
