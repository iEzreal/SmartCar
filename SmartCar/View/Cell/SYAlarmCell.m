//
//  SYAlarmCell.m
//  SmartCar
//
//  Created by Ezreal on 16/7/8.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYAlarmCell.h"

@interface SYAlarmCell ()

@property(nonatomic, strong) UILabel *typeLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *valueLabel;

@end

@implementation SYAlarmCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.font = [UIFont systemFontOfSize:14];
    _typeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_typeLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_timeLabel];
    
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.font = [UIFont systemFontOfSize:14];
    _valueLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_valueLabel];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.width.equalTo(self.contentView).dividedBy(3);
        make.height.equalTo(@40);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel);
        make.left.equalTo(_typeLabel.mas_right);
        make.width.equalTo(self.contentView).dividedBy(3);
        make.height.equalTo(_typeLabel);
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel);
        make.left.equalTo(_timeLabel.mas_right);
        make.width.equalTo(self.contentView).dividedBy(3);
        make.height.equalTo(_typeLabel);
    }];
    
    return self;
}

- (void)boundDataWithAlarm:(SYAlarm *)alarm {
    _timeLabel.text = alarm.gpstime;
    NSString *statuStr = [SYUtil intToBinary:[alarm.alarmStatu intValue]];
    // 超速报警(第6个bit)
    // 进入电子围栏报警 8
    // 越出电子围栏报警 9
    // 震动报警 11
    // 终端欠压  15
    // 发动机超转速报警 23
    // 发动机异常报警  24
    // 发动机水温过高报警 25
    NSString *str6 = [statuStr substringWithRange:NSMakeRange(32 - 6, 1)];
    NSString *str8 = [statuStr substringWithRange:NSMakeRange(32 - 8, 1)];
    NSString *str9 = [statuStr substringWithRange:NSMakeRange(32 - 9, 1)];
    NSString *str11 = [statuStr substringWithRange:NSMakeRange(32 - 11, 1)];
    NSString *str15 = [statuStr substringWithRange:NSMakeRange(32 - 15, 1)];
    NSString *str23 = [statuStr substringWithRange:NSMakeRange(32 - 23, 1)];
    NSString *str24 = [statuStr substringWithRange:NSMakeRange(32 - 24, 1)];
    NSString *str25 = [statuStr substringWithRange:NSMakeRange(32 - 25, 1)];

//    NSLog(@"-----------%@", statuStr);
    NSString *alarmDesc = @"";
    if ([str6 isEqualToString:@"1"]) {
        alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"超速报警"];
        _valueLabel.text = alarm.OBDSpeed;

    }
    
    if ([str8 isEqualToString:@"1"]) {
        alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"进入电子围栏报警"];
        _valueLabel.text = @"";
    }
    
    if ([str9 isEqualToString:@"1"]) {
        alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"越出电子围栏报警"];
        _valueLabel.text = @"";
    }
    
    if ([str11 isEqualToString:@"1"]) {
        alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"震动报警"];
        _valueLabel.text = @"";
    }
    
    if ([str15 isEqualToString:@"1"]) {
        alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"终端欠压"];
        _valueLabel.text = @"";
    }
    
    if ([str23 isEqualToString:@"1"]) {
        alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"发动机超转速报警"];
        _valueLabel.text = alarm.OBDRpm;
    }
    
    if ([str24 isEqualToString:@"1"]) {
        alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"发动机异常报警"];
        _valueLabel.text = @"";
    }
    
    if ([str25 isEqualToString:@"1"]) {
        alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"发动机水温过高报警"];
        _valueLabel.text = alarm.OBDCoolTemp;
    }
    
    _typeLabel.text = alarmDesc;
}

@end
