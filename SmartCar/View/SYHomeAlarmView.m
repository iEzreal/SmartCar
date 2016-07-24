//
//  SYHomeAlarmView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeAlarmView.h"
#import "SYHomeMoreView.h"

@interface SYHomeAlarmView ()

@property(nonatomic, strong) UIButton *eventBtn;
@property(nonatomic, strong) SYHomeMoreView *moreView;
@property(nonatomic, strong) UILabel *alarmLabel;

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
    
    _moreView = [[SYHomeMoreView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
    _moreView.title = @"近期报警";
    _moreView.image = [UIImage imageNamed:@"icon_alarm"];
    _moreView.moreBGColor = TAB_SELECTED_COLOR;
    [self addSubview:_moreView];
    
    _alarmLabel = [[UILabel alloc] init];
    _alarmLabel.textAlignment = NSTextAlignmentCenter;
    _alarmLabel.numberOfLines = 0;
    _alarmLabel.textColor = [UIColor whiteColor];
    _alarmLabel.font = [UIFont systemFontOfSize:15];
    _alarmLabel.text = @"最近十天内无报警记录，请查看更多行程信息";
    [self addSubview:_alarmLabel];
    [_alarmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moreView.mas_bottom);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-5);
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
    if (count > 4) {
        count = 4;
    }
    
    NSString *alarmStr = @"";
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            NSString *time = [alarmArray[i] objectForKey:@"gpstime"];
            NSString *statuStr = [alarmArray[i] objectForKey:@"AlarmStatu"];;
            NSArray *statuArray = [SYUtil int2Binary:[statuStr intValue]];
            NSString *alarmDesc = @"";
            // 超速报警(第7个bit)
            if ([statuArray[6] intValue] == 1) {
                alarmDesc = [NSString stringWithFormat:@"%@%@", alarmDesc, @"超速报警"];
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
            }
            
            // 发动机异常报警 25
            if ([statuArray[24] intValue] == 1) {
                alarmDesc = [NSString stringWithFormat:@"%@", @"发动机异常报警"];
            }
            
            // 发动机水温过高报警 26
            if ([statuArray[25] intValue] == 1) {
                alarmDesc = [NSString stringWithFormat:@"%@", @"发动机异常报警"];
            }
            
            if ([alarmStr isEqualToString:@""]) {
                alarmStr = [NSString stringWithFormat:@"%@%@",time, alarmDesc];
            } else {
                alarmStr = [NSString stringWithFormat:@"%@\n%@%@",alarmStr, time, alarmDesc];
            }
        }
    }
    
    _alarmLabel.text = alarmStr;
}

@end
