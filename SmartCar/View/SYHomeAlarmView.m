//
//  SYHomeAlarmView.m
//  SmartCar
//
//  Created by xxx on 16/7/4.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYHomeAlarmView.h"

@interface SYHomeAlarmView ()

@property(nonatomic, strong) UIButton *eventBtn;

@property(nonatomic, strong) UIImageView *iconIV;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *alarm1Label;
@property(nonatomic, strong) UILabel *alarm2Label;
@property(nonatomic, strong) UIImageView *moreIV;

@end

@implementation SYHomeAlarmView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _eventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _eventBtn.frame = CGRectMake(0, 0, self.width, self.height);
    [_eventBtn setBackgroundImage:[UIImage imageWithColor:PAGE_BG_COLOR] forState:UIControlStateNormal];
    [_eventBtn setBackgroundImage:[UIImage imageWithColor:TAB_SELECTED_COLOR] forState:UIControlStateHighlighted];
    [_eventBtn addTarget:self action:@selector(clickEventAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_eventBtn];
    
    _iconIV = [[UIImageView alloc] init];
    _iconIV.image = [UIImage imageNamed:@"icon_alarm"];
    [self addSubview:_iconIV];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.text = @"近期\n警报";
    [self addSubview:_titleLabel];
    
    _moreIV = [[UIImageView alloc] init];
    _moreIV.image = [UIImage imageNamed:@"check_more_blue"];
    [self addSubview:_moreIV];
    
    _alarm1Label = [[UILabel alloc] init];
    _alarm1Label.textColor = [UIColor whiteColor];
    _alarm1Label.font = [UIFont systemFontOfSize:16];
    [self addSubview:_alarm1Label];
    
    _alarm2Label = [[UILabel alloc] init];
    _alarm2Label.textColor = [UIColor whiteColor];
    _alarm2Label.font = [UIFont systemFontOfSize:16];
    [self addSubview:_alarm2Label];


    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.width.height.equalTo(@33);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(_iconIV.mas_right).offset(5);
        make.centerY.equalTo(_iconIV);
        make.width.equalTo(@32);
    }];
    
    [_alarm1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(_titleLabel.mas_right).offset(10);
        make.right.equalTo(_moreIV.mas_left).offset(-10);
    }];
    
    [_alarm2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_alarm1Label.mas_bottom).offset(4);
        make.left.equalTo(_alarm1Label);
        make.right.equalTo(_alarm1Label);
    }];
    
    [_moreIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(_iconIV);
        make.width.equalTo(@50);
    }];
    
    return self;

}

- (void)clickEventAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(moreAlarmAction)]) {
        [self.delegate moreAlarmAction];
    }
}

- (void)setAlarmArray:(NSArray *)alarmArray {
    NSInteger count = alarmArray.count;
    if (count > 2) {
        count = 2;
    }
    
    for (int i = 0; i < count; i++) {
        NSString *alarmStr = @"";
        @autoreleasepool {
            NSString *time = [SYUtil dateWithSateStr:[alarmArray[i] objectForKey:@"gpstime"] Format:@"MM月dd日 HH:mm"];
            NSString *statuStr = [alarmArray[i] objectForKey:@"AlarmStatu"];;
            NSArray *statuArray = [SYUtil int2Binary:[statuStr intValue]];
            NSString *alarmDesc = @"";
            NSString *alarmValue = @"";
            // 超速报警(第7个bit)
            if ([statuArray[6] intValue] == 1) {
                alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"超速报警"];
                alarmValue = [NSString stringWithFormat:@"%.1fkm/h", [[alarmArray[i] objectForKey:@"OBDSpeed"] floatValue] * 0.1];
            }
            
            // 进入电子围栏报警 9
            if ([statuArray[8] intValue] == 1) {
                alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"进入电子围栏"];
            }
            
            // 越出电子围栏报警 10
            if ([statuArray[9] intValue] == 1) {
                alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"越出电子围栏"];
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
                alarmValue = [NSString stringWithFormat:@"转速%@", [alarmArray[i] objectForKey:@"OBDRpm"]];
               
            }
            
            // 发动机异常报警 25
            if ([statuArray[24] intValue] == 1) {
                alarmDesc = [NSString stringWithFormat:@"%@", @"发动机异常报警"];
            }
            
            // 发动机水温过高报警 26
            if ([statuArray[25] intValue] == 1) {
                alarmDesc = [NSString stringWithFormat:@"%@", @"发动机水温过高报警"];
                alarmValue = [NSString stringWithFormat:@"温度%@", [alarmArray[i] objectForKey:@"OBDCoolTemp"]];
            }
            
            if (![alarmValue isEqualToString:@""]) {
                alarmValue = [NSString stringWithFormat:@"-%@",alarmValue];
            }
            
            alarmStr = [NSString stringWithFormat:@"%@-%@%@",time, alarmDesc, alarmValue];
        }
        
        if (i == 0) {
            _alarm1Label.text = alarmStr;
        } else {
            _alarm2Label.text = alarmStr;
        }
    }
}

@end
