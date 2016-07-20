//
//  SYHomeGaugeView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeGaugeView.h"

@interface SYHomeGaugeView ()

@property(nonatomic, strong) UIView *refreshView;
@property(nonatomic, strong) UIButton *refreshBtn;
@property(nonatomic, strong) UILabel *refreshTimeLabel;

@property(nonatomic, strong) UIView *leftView;
@property(nonatomic, strong) SYProgressView *oilPV;
@property(nonatomic, strong) UILabel *oilLabel;

@property(nonatomic, strong) UIView *centerView;
@property(nonatomic, strong) UIImageView *speedIV;
@property(nonatomic, strong) UILabel *speedLabel;

@property(nonatomic, strong) UIView *rightView;
@property(nonatomic, strong) UIImageView *stateIV;
@property(nonatomic, strong) UIImageView *voltageIV;
@property(nonatomic, strong) UILabel *voltageLabel;

@property(nonatomic, strong) UILabel *mileageLabel;

@property(nonatomic, assign) BOOL isRefreshing;

@end

@implementation SYHomeGaugeView


- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    // 上面区域
    _refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    [self addSubview:_refreshView];
    
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refreshBtn setImage:[UIImage imageNamed:@"refrush"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [_refreshView addSubview:_refreshBtn];
    
    _refreshTimeLabel = [[UILabel alloc] init];
    _refreshTimeLabel.font = [UIFont systemFontOfSize:16];
    _refreshTimeLabel.textColor = [UIColor whiteColor];
    _refreshTimeLabel.text = @"0000-00-00 00:00";
    [_refreshView addSubview:_refreshTimeLabel];
    
    [_refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@30);
    }];
    
    [_refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_refreshView).offset(5);
        make.centerY.equalTo(_refreshView);
    }];
    
    [_refreshTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_refreshBtn.mas_right).offset(5);
        make.centerY.equalTo(_refreshView);
    }];
    
    // 左侧区域
    _leftView = [[UIView alloc] init];
    [self addSubview:_leftView];
    
    _oilPV = [[SYProgressView alloc] init];
    [self addSubview:_oilPV];
    
    _oilLabel = [[UILabel alloc] init];
    _oilLabel.font = [UIFont systemFontOfSize:16];
    _oilLabel.textColor = [UIColor whiteColor];
    _oilLabel.text = @"0%";
    [self addSubview:_oilLabel];
    
    // 中间区域
    _speedIV = [[UIImageView alloc] init];
    _speedIV.contentMode = UIViewContentModeScaleAspectFill;
    _speedIV.image = [UIImage imageNamed:@"gauge_speed"];
    [self addSubview:_speedIV];
    
    _speedLabel = [[UILabel alloc] init];
    _speedLabel.textAlignment = NSTextAlignmentCenter;
    _speedLabel.font = [UIFont systemFontOfSize:20];
    _speedLabel.textColor = [UIColor whiteColor];
    _speedLabel.text = @"0.0";
    [self addSubview:_speedLabel];
    
    
    // 右侧区域
    _rightView = [[UIView alloc] init];
    [self addSubview:_rightView];
    
    _stateIV = [[UIImageView alloc] init];
    _stateIV.image = [UIImage imageNamed:@"gauge_state_stop"];
    [self addSubview:_stateIV];
    
    // 电压
    _voltageIV = [[UIImageView alloc] init];
    _voltageIV.image = [UIImage imageNamed:@"gauge_voltage"];
    [self addSubview:_voltageIV];
    
    _voltageLabel = [[UILabel alloc] init];
    _voltageLabel.textAlignment = NSTextAlignmentCenter;
    _voltageLabel.font = [UIFont systemFontOfSize:16];
    _voltageLabel.textColor = [UIColor whiteColor];
    _voltageLabel.text = @"0.0V";
    [self addSubview:_voltageLabel];

    
    // 下面区域
    _mileageLabel = [[UILabel alloc] init];
    _mileageLabel.textAlignment = NSTextAlignmentCenter;
    _mileageLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _mileageLabel.font = [UIFont systemFontOfSize:18];
    _mileageLabel.textColor = [UIColor whiteColor];
    _mileageLabel.text = @"总里程0000000km";
    [self addSubview:_mileageLabel];
    
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_refreshView.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(_speedIV.mas_left);
        make.bottom.equalTo(_mileageLabel.mas_top);
    }];
    
    [_oilPV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftView);
        make.centerY.equalTo(_speedIV).offset(10);
        make.width.height.equalTo(@60);
    }];
    
    [_oilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oilPV.mas_bottom).offset(5);
        make.centerX.equalTo(_leftView);
    }];
    
    
    [_speedIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_refreshView.mas_bottom);
        make.centerX.equalTo(self);
    }];
    
    [_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_speedIV.mas_bottom).offset(3);
        make.centerX.equalTo(self);
    }];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_speedIV);
        make.left.equalTo(_speedIV.mas_right);
        make.right.equalTo(self);
        make.bottom.equalTo(_speedLabel);
    }];

    [_stateIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightView).offset(15);
        make.centerX.equalTo(_rightView);
    }];

    [_voltageIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightView.mas_centerY);
        make.centerX.equalTo(_rightView);
    }];
    
    [_voltageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_voltageIV.mas_bottom).offset(5);
        make.centerX.equalTo(_rightView);
    }];

    
    [_mileageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@30);
        make.bottom.equalTo(self);
    }];

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
    [_oilPV setProgress:[oilText floatValue] / 100 animated:YES];
    _oilLabel.text = [NSString stringWithFormat:@"%@%@", oilText, @"%"];
}

- (void)setSpeedText:(NSString *)speedText {
    _speedText = speedText;
    _speedLabel.text = [NSString stringWithFormat:@"%.1f", [speedText floatValue] / 10];
}

- (void)setStateText:(NSString *)stateText {
    if ([stateText isEqualToString:@"0"]) {
        _stateIV.image = [UIImage imageNamed:@"gauge_state_stop"];
    } else {
        _stateIV.image = [UIImage imageNamed:@"gauge_state_running"];
    }
}

- (void)setVoltageText:(NSString *)voltageText {
    _voltageText = voltageText;
    _voltageLabel.text = [NSString stringWithFormat:@"%0.1f%@", [voltageText floatValue] / 10, @"V"];
}

- (void)setMileageText:(NSString *)mileageText {
    _mileageText = [NSString stringWithFormat:@"%ld", [mileageText integerValue] / 10];
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
