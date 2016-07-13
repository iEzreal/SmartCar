//
//  NSDate+Extension.h
//  SmartCar
//
//  Created by Ezreal on 16/7/13.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
+ (NSString *)currentDate;
- (NSString *)dateAfterDay:(NSUInteger)day;
+ (NSString *)dateAfterDate:(NSDate *)date day:(NSInteger)day;
+ (NSString *)dateStrAfterDate:(NSDate *)date day:(NSInteger)day;
+ (NSString *)dateAfterDate:(NSDate *)date month:(NSInteger)month;

@end
