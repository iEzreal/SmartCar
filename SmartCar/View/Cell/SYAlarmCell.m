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
    _typeLabel.font = [UIFont systemFontOfSize:15];
    _typeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_typeLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_timeLabel];
    
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.font = [UIFont systemFontOfSize:15];
    _valueLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_valueLabel];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.width.equalTo(self.contentView).dividedBy(3);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeLabel.mas_right);
        make.width.equalTo(self.contentView).dividedBy(3);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_right);
        make.width.equalTo(self.contentView).dividedBy(3);
        make.centerY.equalTo(self.contentView);
    }];
    
    return self;
}

- (void)boundDataWithAlarm:(SYAlarm *)alarm {
    
    NSArray *statuArray = [SYUtil int2Binary:[alarm.alarmStatu intValue]];
    NSString *alarmDesc = @"";
    NSString *alarmValue = @"";
    NSLog(@"------警告码：%@", [SYUtil intToBinary:[alarm.alarmStatu intValue]]);
    // 超速报警(第7个bit)
    if ([statuArray[6] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"超速报警"];
        alarmValue = [NSString stringWithFormat:@"%.1fkm/h", [alarm.OBDSpeed floatValue] * 0.1];
    }
    
    // 进入电子围栏报警 9
    if ([statuArray[8] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"进入电子围栏"];
    }
    
    //  越出电子围栏报警 10
    if ([statuArray[9] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"越出电子围栏"];
    }
    
    // 震动报警 12
    if ([statuArray[11] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"震动报警"];
    }
    
    // 终端欠压 16
    if ([statuArray[15] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"终端欠压"];
    }
    
    // 发动机超转速报警 24
    if ([statuArray[23] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"发动机超转速报警"];
        alarmValue = [NSString stringWithFormat:@"转速%@", alarm.OBDRpm];
    }

    // 发动机异常报警 25
    if ([statuArray[24] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"发动机异常报警"];
    }
    
    // 发动机水温过高报警 26
    if ([statuArray[25] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"发动机异常报警"];
        alarmValue = [NSString stringWithFormat:@"转速%@", alarm.OBDCoolTemp];
    }
    _timeLabel.text = [SYUtil dateWithSateStr:alarm.gpstime Format:@"yyyy.MM.dd HH.mm"];
    _typeLabel.text = alarmDesc;
    _valueLabel.text = alarmValue;
}

@end
