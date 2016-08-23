//
//  SYUtil.h
//  SmartCar
//
//  Created by xxx on 16/7/7.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYUtil : NSObject

+ (NSArray *)int2Binary:(int)intValue;
+ (NSString *)intToBinary:(int)intValue;

+ (NSString *)currentDate;
+ (NSInteger)currentYear;
+ (NSInteger)currentMonth;
+ (NSInteger)currentDay;

+ (NSInteger)daysOfMonth:(NSInteger)month;

+ (NSString *)dateWithSateStr:(NSString *)dateStr Format:(NSString *)format;
+ (NSString *)intervalFromTime:(NSString *)startTime toTime:(NSString *) endTime;

+ (void)showWithStatus:(NSString *)status;
+ (void)showHintWithStatus:(NSString *)status duration:(NSTimeInterval)duration;
+ (void)showErrorWithStatus:(NSString *)status duration:(NSTimeInterval)duration;
+ (void)showSuccessWithStatus:(NSString *)status duration:(NSTimeInterval)duration;
+ (void)dismissProgressHUD;
@end
