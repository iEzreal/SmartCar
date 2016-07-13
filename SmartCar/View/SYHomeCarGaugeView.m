//
//  SYHomeCarGaugeView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeCarGaugeView.h"
#import "SYHomeOilGaugeView.h"
#import "SYHomeSpeedGaugeView.h"
#import "SYHomeVoltageGaugeView.h"
#import "SYHomeStateGaugeView.h"

@interface SYHomeCarGaugeView ()

@property(nonatomic, strong) UIButton *refreshBtn;
@property(nonatomic, strong) UILabel *refreshTimeLabel;

@property(nonatomic, strong) SYHomeOilGaugeView *oilGaugeView;
@property(nonatomic, strong) SYHomeSpeedGaugeView *speedGaugeView;
@property(nonatomic, strong) SYHomeStateGaugeView *stateGaugeView;
@property(nonatomic, strong) SYHomeVoltageGaugeView *voltageGaugeView;
@property(nonatomic, strong) UILabel *mileageLabel;

@property(nonatomic, assign) BOOL isRefreshing;

@end

@implementation SYHomeCarGaugeView


- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    // 刷新View
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    [self addSubview:refreshView];
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshBtn.frame = CGRectMake(11, 11, 21, 18);
    [_refreshBtn setImage:[UIImage imageNamed:@"refrush"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [refreshView addSubview:_refreshBtn];
    _refreshTimeLabel = [[UILabel alloc] init];
    _refreshTimeLabel.frame = CGRectMake(_refreshBtn.right + 5, 0, self.width - _refreshBtn.right - 10, 40);
    _refreshTimeLabel.font = [UIFont systemFontOfSize:16];
    _refreshTimeLabel.textColor = [UIColor whiteColor];
    _refreshTimeLabel.text = @"0000-00-00 00:00";
    [refreshView addSubview:_refreshTimeLabel];
    
    // 速度
    _speedGaugeView = [[SYHomeSpeedGaugeView alloc] initWithFrame:CGRectMake(self.width / 2 - 80, 40, 160, 160)];
    _speedGaugeView.text = @"0.0";
    [self addSubview:_speedGaugeView];
    
    // 油量
    _oilGaugeView = [[SYHomeOilGaugeView alloc] initWithFrame:CGRectMake(_speedGaugeView.left / 2 - 30, _speedGaugeView.bottom - 90, 60, 90)];
    _oilGaugeView.text = @"0%";
    [self addSubview:_oilGaugeView];
    
    
    // 行驶状态
    _stateGaugeView = [[SYHomeStateGaugeView alloc] initWithFrame:CGRectMake(_speedGaugeView.right, _speedGaugeView.top, SCREEN_W - _speedGaugeView.right, 40)];
    [self addSubview:_stateGaugeView];
    
    // 电压
    _voltageGaugeView = [[SYHomeVoltageGaugeView alloc] initWithFrame:CGRectMake(_speedGaugeView.right, _speedGaugeView.centerY, SCREEN_W - _speedGaugeView.right, 60)];
    _voltageGaugeView.text = @"0v";
    [self addSubview:_voltageGaugeView];
    
    _mileageLabel = [[UILabel alloc] init];
    _mileageLabel.frame = CGRectMake(0, _speedGaugeView.bottom, self.width, 40);
    _mileageLabel.textAlignment = NSTextAlignmentCenter;
    _mileageLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _mileageLabel.textColor = [UIColor whiteColor];
    _mileageLabel.font = [UIFont systemFontOfSize:18];
    _mileageLabel.text = @"总里程0000000km";
    [self addSubview:_mileageLabel];
    return self;
}

- (void)refreshAction:(UIButton *)sender {
    if (!_isRefreshing) {
        if (_block) {
            _isRefreshing = true;
            [self startRefresh];
            _block();
        }
    }
}

- (void)startRefresh {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.65;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSIntegerMax;
    [_refreshBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)endRefresh {
    _isRefreshing = false;
    [_refreshBtn.layer removeAllAnimations];
}



- (void)setRefreshTimeText:(NSString *)refreshTimeText {
    _refreshTimeText = refreshTimeText;
    _refreshTimeLabel.text = refreshTimeText;
}

- (void)setOilText:(NSString *)oilText {
    _oilText = oilText;
    _oilGaugeView.text = [NSString stringWithFormat:@"%@%@", oilText, @"%"];
}

- (void)setSpeedText:(NSString *)speedText {
    _speedText = speedText;
    _speedGaugeView.text = [NSString stringWithFormat:@"%.1f", [speedText floatValue] / 10];
}

- (void)setStateText:(NSString *)stateText {
    if ([stateText isEqualToString:@"0"]) {
        _stateGaugeView.stateColor = [UIColor redColor];
        _stateGaugeView.stateText = @"停止";
    } else {
        _stateGaugeView.stateColor = [UIColor greenColor];
        _stateGaugeView.stateText = @"行驶中";
    }
}

- (void)setVoltageText:(NSString *)voltageText {
    _voltageText = voltageText;
    _voltageGaugeView.text = [NSString stringWithFormat:@"%0.1f%@", [voltageText floatValue] / 10, @"V"];
}

- (void)setMileageText:(NSString *)mileageText {
    _mileageText = [NSString stringWithFormat:@"%d", [mileageText integerValue] / 10];
    NSUInteger len = _mileageText.length;
    NSMutableString *str = [NSMutableString stringWithString:_mileageText];
    for (NSUInteger i = len; i < 8; i++) {
        [str insertString:@"0" atIndex:0];
    }
    str = [NSMutableString stringWithFormat:@"总里程 %@km", str];
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 3)];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(4, 8)];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(12, 2)];
    _mileageLabel.attributedText = mutStr;
}

@end
