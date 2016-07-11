//
//  SYSettingMileageController.m
//  SmartCar
//
//  Created by liuyiming on 16/7/9.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYSettingMileageController.h"

@interface SYSettingMileageController ()

@property(nonatomic, strong) UIImageView *mileageLogo;
@property(nonatomic, strong) UILabel *mileageLabel;
@property(nonatomic, strong) UILabel *carHintLabel;
@property(nonatomic, strong) UILabel *carNumLabel;
@property(nonatomic, strong) UIButton *selectCarBtn;
@property(nonatomic, strong) UILabel *mileageHintLabel;
@property(nonatomic, strong) UITextField *mileageTF;

@property(nonatomic, strong) UIButton *saveBtn;


@end

@implementation SYSettingMileageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"初始里程";
    self.view.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    
    _mileageLogo = [[UIImageView alloc] init];
    _mileageLogo.image = [UIImage imageNamed:@"mine_mileage"];
    [self.view addSubview:_mileageLogo];
    
    _mileageLabel = [[UILabel alloc] init];
    _mileageLabel.font = [UIFont systemFontOfSize:18];
    _mileageLabel.textColor = [UIColor whiteColor];
    _mileageLabel.text = @"设置初始里程";
    [self.view addSubview:_mileageLabel];
    
    _carHintLabel = [[UILabel alloc] init];
    _carHintLabel.font = [UIFont systemFontOfSize:17];
    _carHintLabel.textColor = [UIColor whiteColor];
    _carHintLabel.text = @"请选择车辆:";
    [self.view addSubview:_carHintLabel];
    
    _carNumLabel = [[UILabel alloc] init];
    _carNumLabel.font = [UIFont systemFontOfSize:17];
    _carNumLabel.textColor = [UIColor whiteColor];
    _carNumLabel.text = @"q请选择车辆";
    [self.view addSubview:_carNumLabel];
    
    _selectCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectCarBtn.backgroundColor = [UIColor redColor];
    [_selectCarBtn addTarget:self action:@selector(mileageClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectCarBtn];
    
    _mileageHintLabel = [[UILabel alloc] init];
    _mileageHintLabel.font = [UIFont systemFontOfSize:17];
    _mileageHintLabel.textColor = [UIColor whiteColor];
    _mileageHintLabel.text = @"仪表盘里程:";
    [self.view addSubview:_mileageHintLabel];
    
    _mileageTF = [[UITextField alloc] init];
    _mileageTF.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:_mileageTF];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_save_n"] forState:UIControlStateNormal];
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_save_h"] forState:UIControlStateHighlighted];
    [_saveBtn addTarget:self action:@selector(mileageClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    
    [_mileageLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    [_mileageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mileageLogo.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    [_carHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mileageLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@100);
    }];
    
    [_selectCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(_carHintLabel);
        make.width.equalTo(@50);
    }];
    
    [_carNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_carHintLabel.mas_right).offset(5);
        make.right.equalTo(_selectCarBtn.mas_left).offset(-5);
        make.centerY.equalTo(_carHintLabel);
    }];
    
    [_mileageHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_carHintLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(_carHintLabel);
    }];
    
    [_mileageTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mileageHintLabel);
        make.left.equalTo(_mileageHintLabel.mas_right).offset(5);
        make.right.equalTo(_selectCarBtn);
    }];
    
   
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mileageHintLabel.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
    }];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)mileageClickAction:(UIButton *)sender{

}

@end