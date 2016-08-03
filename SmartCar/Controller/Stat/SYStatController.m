//
//  SYStatController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYStatController.h"
#import "SYAlarmStatController.h"
#import "SYGasStatController.h"
#import "SYOilExceptionController.h"
#import "SYTravelIInfoController.h"
#import "SYLoginController.h"
#import "AppDelegate.h"

@interface SYStatController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *menuIV;
@property (nonatomic, strong) UIButton *alarmBtn;
@property (nonatomic, strong) UIButton *gasBtn;
@property (nonatomic, strong) UIButton *oilExceBtn;
@property (nonatomic, strong) UIButton *carTravelBtn;

@end

@implementation SYStatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = TAB_SELECTED_COLOR;
    [self.view addSubview:_topView];
    
    _iconIV = [[UIImageView alloc] init];
    _iconIV.image = [UIImage imageNamed:@"icon_stat"];
    [_topView addSubview:_iconIV];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"各类统计";
    [_topView addSubview:_titleLabel];

    
    _bottomView = [[UIView alloc] init];
    [self.view addSubview:_bottomView];
    
    _menuIV = [[UIImageView alloc] init];
    _menuIV.image = [UIImage imageNamed:@"stat_menu_bg"];
    [_bottomView addSubview:_menuIV];
    
    _alarmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_alarmBtn setImage:[UIImage imageNamed:@"alarm_normal"] forState:UIControlStateNormal];
    [_alarmBtn setImage:[UIImage imageNamed:@"alarm_highlight"] forState:UIControlStateHighlighted];
    [_alarmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_alarmBtn setTitle:@"报警" forState:UIControlStateNormal];
    [_alarmBtn addTarget:self action:@selector(statButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _alarmBtn.tag = 1;
    [_bottomView addSubview:_alarmBtn];
    
    _gasBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gasBtn setImage:[UIImage imageNamed:@"sgasadd_normal"] forState:UIControlStateNormal];
    [_gasBtn setImage:[UIImage imageNamed:@"sgasadd_highlight"] forState:UIControlStateHighlighted];
    [_gasBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gasBtn setTitle:@"加油" forState:UIControlStateNormal];
    [_gasBtn addTarget:self action:@selector(statButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _gasBtn.tag = 2;
    [_bottomView addSubview:_gasBtn];
    
    _oilExceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_oilExceBtn setImage:[UIImage imageNamed:@"gasdec_normal"] forState:UIControlStateNormal];
    [_oilExceBtn setImage:[UIImage imageNamed:@"gasdec_highlight"] forState:UIControlStateHighlighted];
    [_oilExceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_oilExceBtn setTitle:@"油量异常" forState:UIControlStateNormal];
    [_oilExceBtn addTarget:self action:@selector(statButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _oilExceBtn.tag = 3;
    [_bottomView addSubview:_oilExceBtn];
    
    _carTravelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_carTravelBtn setImage:[UIImage imageNamed:@"stat_travel_normal"] forState:UIControlStateNormal];
    [_carTravelBtn setImage:[UIImage imageNamed:@"stat_travel_highlight"] forState:UIControlStateHighlighted];
    [_carTravelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_carTravelBtn setTitle:@"车辆行驶信息" forState:UIControlStateNormal];
    [_carTravelBtn addTarget:self action:@selector(statButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _carTravelBtn.tag = 4;
    [_bottomView addSubview:_carTravelBtn];
    
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(6);
        make.centerY.equalTo(_topView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconIV.mas_right).offset(6);
        make.centerY.equalTo(_topView);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-113);
    }];

    [_menuIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView);
        make.centerY.equalTo(_bottomView);
        make.width.equalTo(@(125 * SCALE_H));
        make.height.equalTo(@(280 * SCALE_H));
    }];
    
    [_alarmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_menuIV.mas_top);
        make.left.equalTo(_gasBtn).offset(-60 * SCALE_H);
    }];
    
    [_gasBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_menuIV.mas_right).offset(10);
        make.bottom.equalTo(_bottomView.mas_centerY).offset(-20 * SCALE_H);
    }];
    
    [_oilExceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_centerY).offset(20 * SCALE_H);
        make.left.equalTo(_gasBtn);
    }];
    
    [_carTravelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_menuIV.mas_right).offset(-60 * SCALE_H);
        make.centerY.equalTo(_menuIV.mas_bottom);
    }];

    
}

- (void)statButtonAction:(id)sender {
    NSInteger tag = ((UIButton *)sender).tag;
    if (tag == 1) {
        SYAlarmStatController *alarmController = [[SYAlarmStatController alloc] init];
        [self.navigationController pushViewController:alarmController animated:YES];
        
    } else if (tag == 2) {
        SYGasStatController *gasStatController = [[SYGasStatController alloc] init];
        [self.navigationController pushViewController:gasStatController animated:YES];
    
    } else if (tag == 3) {
        SYOilExceptionController *exceptionController = [[SYOilExceptionController alloc] init];
        [self.navigationController pushViewController:exceptionController animated:YES];

    } else {
        SYTravelIInfoController *travelController = [[SYTravelIInfoController alloc] init];
        [self.navigationController pushViewController:travelController animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
