//
//  NSDate+Extension.h
//  SmartCar
//
//  Created by liuyiming on 16/7/13.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

+ (NSUInteger)year:(NSDate *)date;
+ (NSUInteger)month:(NSDate *)date;
//+ (NSUInteger)day:(NSDate *)date;
//+ (NSUInteger)hour:(NSDate *)date;
//+ (NSUInteger)minute:(NSDate *)date;
//+ (NSUInteger)second:(NSDate *)date;

+ (NSString *)currentDate;
- (NSString *)dateAfterDay:(NSUInteger)day;
+ (NSString *)dateAfterDate:(NSDate *)date day:(NSInteger)day;
- (NSString *)dateAfterMonth:(NSUInteger)month;
+ (NSString *)dateAfterDate:(NSDate *)date month:(NSInteger)month;

@end
