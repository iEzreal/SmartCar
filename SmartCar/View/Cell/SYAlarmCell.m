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
    _typeLabel.font = [UIFont systemFontOfSize:16];
    _typeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_typeLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.numberOfLines = 0;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_timeLabel];
    
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.font = [UIFont systemFontOfSize:16];
    _valueLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_valueLabel];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
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
    _timeLabel.text = alarm.gpstime;
    NSArray *statuArray = [SYUtil int2Binary:[alarm.alarmStatu intValue]];
    NSString *alarmDesc = @"";
    // 超速报警(第6个bit)
    if ([statuArray[5] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"超速报警"];
    }
    
    // 进入电子围栏报警 9
    if ([statuArray[8] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"进入电子围栏"];
    }
    
    //  越出电子围栏报警 10
    if ([statuArray[9] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"越出电子围栏"];
    }
    
    // 震动报警 11
    if ([statuArray[10] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"震动报警"];
    }
    
    // 终端欠压 15
    if ([statuArray[14] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"终端欠压"];
    }
    
    // 发动机超转速报警 23
    if ([statuArray[22] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"发动机超转速报警"];
    }

    // 发动机异常报警 24
    if ([statuArray[23] intValue] == 1) {
        alarmDesc = [NSString stringWithFormat:@"%@", @"发动机异常报警"];
    }


    _typeLabel.text = alarmDesc;
}

@end
