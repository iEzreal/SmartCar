//
//  SYAlarmController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYAlarmController.h"

@interface SYAlarmController ()

@property(nonatomic, strong) UILabel *typeLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *valuelLabel;

@end

@implementation SYAlarmController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"近期警报";
    
    [self setupPageSubviews];
    [self layoutPageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupPageSubviews {
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _typeLabel.font = [UIFont systemFontOfSize:14];
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.text = @"报警类型";
    [self.view addSubview:_typeLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = @"时间";
    [self.view addSubview:_timeLabel];
    
    _valuelLabel = [[UILabel alloc] init];
    _valuelLabel.textAlignment = NSTextAlignmentCenter;
    _valuelLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _valuelLabel.font = [UIFont systemFontOfSize:14];
    _valuelLabel.textColor = [UIColor whiteColor];
    _valuelLabel.text = @"报警值";
    [self.view addSubview:_valuelLabel];
}

- (void)layoutPageSubviews {
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(@40);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel);
        make.left.equalTo(_typeLabel.mas_right);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(_typeLabel);
    }];
    
    [_valuelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel);
        make.left.equalTo(_timeLabel.mas_right);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(_typeLabel);
    }];
    
}


@end
