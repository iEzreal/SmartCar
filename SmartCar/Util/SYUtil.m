//
//  SYUtil.m
//  SmartCar
//
//  Created by Ezreal on 16/7/7.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYUtil.h"

@implementation SYUtil

+ (NSArray *)int2Binary:(int)intValue {
    int byteBlock = 8;
    int binaryDigit = (sizeof(int)) * byteBlock; // Total bits
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:binaryDigit];
    while (binaryDigit-- > 0) {
        [array addObject:[NSNumber numberWithInt:(intValue & 1) ? 1 : 0]];
        intValue >>= 1;
    }
    return [[array reverseObjectEnumerator] allObjects];
}



+ (NSString *)intToBinary:(int)intValue{
    int byteBlock = 8;
    int totalBits = (sizeof(int)) * byteBlock; // Total bits
    int binaryDigit = totalBits;
    char ndigit[totalBits + 1];
    while (binaryDigit-- > 0) {
        // Set digit in array based on rightmost bit
        ndigit[binaryDigit] = (intValue & 1) ? '1' : '0';
        // Shift incoming value one to right
        intValue >>= 1;
    }   // Append null
    ndigit[totalBits] = 0;
    return [NSString stringWithUTF8String:ndigit];

}

+ (NSString *)dateAfterDate:(NSDate *)date day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:dateAfterDay];

    return dateStr;
}

+ (NSString *)currentDate {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    return dateStr;
}

+ (NSString *)intervalFromTime:(NSString *)startTime toTime:(NSString *) endTime {
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSDate *sDate = [date dateFromString:startTime];
    NSTimeInterval s = [sDate timeIntervalSince1970];
    
    NSDate *eDate = [date dateFromString:endTime];
    NSTimeInterval e = [eDate timeIntervalSince1970];
    
    NSTimeInterval cha = e - s;
    NSString *timeString = @"";
    NSString *house = @"";
    NSString *min = @"";
    NSString *sec = @"";
    
    sec = [NSString stringWithFormat:@"%d", (int)cha % 60];
    min = [NSString stringWithFormat:@"%d", (int)cha / 60 % 60];
    house = [NSString stringWithFormat:@"%d", (int)cha / 3600];
    timeString=[NSString stringWithFormat:@"%@小时%@分", house, min];
    return timeString;
}

+ (void)showHintWithStatus:(NSString *)status duration:(NSTimeInterval)duration {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:duration];
    [SVProgressHUD showInfoWithStatus:status];
}

@end
