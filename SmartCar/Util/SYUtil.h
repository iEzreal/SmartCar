//
//  SYUtil.h
//  SmartCar
//
//  Created by Ezreal on 16/7/7.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYUtil : NSObject

+ (NSString *)currentDate;
+ (NSString *)dateAfterDate:(NSDate *)date day:(NSInteger)day;
+ (NSString *)intervalFromTime:(NSString *)startTime toTime:(NSString *) endTime;
+ (NSString *)intToBinary:(int)intValue;
+ (void)showHintWithStatus:(NSString *)status duration:(NSTimeInterval)duration;

@end
