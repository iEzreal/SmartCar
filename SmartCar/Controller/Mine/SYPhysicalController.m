//
//  SYPhysicalController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/8.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYPhysicalController.h"
#import "SYPhysicalCell.h"
#import "SYPageTopView.h"
#import "SYDtcCode.h"

@interface SYPhysicalController () <SYPageTopViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) SYPageTopView *topView;
@property(nonatomic, strong) UIView *menuView;
@property(nonatomic, strong) UILabel *faultCodeLabel;
@property(nonatomic, strong) UILabel *faultDescLabel;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dtcCodeArray;

@end

@implementation SYPhysicalController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dtcCodeArray = [[NSMutableArray alloc] init];
    
    [self setupPageSubviews];
    
//    // 跳过请求DTC命令，直接测试翻译
//    NSString *dtcCode = @"P0100P0200P0300C0300B0200U0100P0101";
//    NSString *newDtcCode = @"";
//    for (int i = 0; i < dtcCode.length / 5; i++) {
//        NSString *str = [dtcCode substringWithRange:NSMakeRange(i * 5, 5)];
//        NSString *str2 = [NSString stringWithFormat:@"'%@'", str];
//        if ([newDtcCode isEqualToString:@""]) {
//            newDtcCode = [NSString stringWithFormat:@"%@",str2];
//        } else {
//            newDtcCode = [NSString stringWithFormat:@"%@,%@",newDtcCode ,str2];
//        }
//    }
//    [self dtcTranslate:newDtcCode];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据请求
/**
 *  发送DTC查询命令
 */
- (void)getDtcCode {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSString *termId = [SYAppManager sharedManager].showVehicle.termID;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"uCarId"];
    [parameters setObject:termId forKey:@"szTermId"];
    [parameters setObject:[NSNumber numberWithInt:5000] forKey:@"nTimeOut"];
    
    [SYUtil showWithStatus:@"正在体检..."];
    [SYApiServer OBD_POST:METHOD_GET_DTC_CODE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if ([[responseDic objectForKey:@"GetDtcCodeResult"] intValue] == 0) {
            // sy235 请求到的数据 -> P0100P0200P0300C0300B0200U0100P0101
            NSString *dtcCode = [responseDic objectForKey:@"dtcCode"];
            if (![dtcCode isEqualToString:@""]) {
                // 格式化dtcCode -> 'P0100','P0200','P0300','C0300','B0200','U0100','P0101'
                NSString *newDtcCode = @"";
                for (int i = 0; i < dtcCode.length / 5; i++) {
                    NSString *str = [dtcCode substringWithRange:NSMakeRange(i * 5, 5)];
                    NSString *str2 = [NSString stringWithFormat:@"'%@'", str];
                    if ([newDtcCode isEqualToString:@""]) {
                        newDtcCode = [NSString stringWithFormat:@"%@",str2];
                    } else {
                        newDtcCode = [NSString stringWithFormat:@"%@,%@",newDtcCode ,str2];
                    }
                }
                // 翻译DTC 命令
                [self dtcTranslate:newDtcCode];
            } else {
                [SYUtil showSuccessWithStatus:@"车辆健康，无故障" duration:2];
            }
        } else {
            [SYUtil showErrorWithStatus:@"体检失败, 请重试" duration:2];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"体检失败, 请重试" duration:2];
    }];
}

/**
 *  翻译DTC错误代码
 *
 *  @param dtcCode 格式化的dtcCode -> 'P0100','P0200','P0300','P0101'
 */
- (void)dtcTranslate:(NSString *)dtcCode {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:dtcCode forKey:@"dtc"];
    [SYApiServer POST:METHOD_DTC_TRANSLATE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"DtcTranslateResult"] intValue] > 0) {
            NSString *dtcInfoStr = [responseDic objectForKey:@"dtcInfo"];
            NSDictionary *dtcInfoDic = [dtcInfoStr objectFromJSONString];
            NSArray *tableInfoArray = [dtcInfoDic objectForKey:@"TableInfo"];
            for (int i = 0; i < tableInfoArray.count; i++) {
                SYDtcCode *dtcCode = [[SYDtcCode alloc] initWithDic:tableInfoArray[i]];
                [_dtcCodeArray addObject:dtcCode];
            }
            [_tableView reloadData];
        } else {
            [SYUtil showErrorWithStatus:@"体检失败" duration:2];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"体检失败" duration:2];
    }];
}

#pragma mark - 代理方法
- (void)topViewRightAction {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"使用该功能，请确保您的车处于停止行驶状态，否则可能发生危险!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self getDtcCode];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dtcCodeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SYPhysicalCell";
    SYPhysicalCell *physicalCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!physicalCell) {
        physicalCell = [[SYPhysicalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        physicalCell.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
        physicalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    physicalCell.faultCode = [_dtcCodeArray[indexPath.row] dtcCode];
    physicalCell.faultDesc = [_dtcCodeArray[indexPath.row] explain];
    return physicalCell;
}

#pragma mark - 页面UI
- (void)setupPageSubviews {
    _topView = [[SYPageTopView alloc] init];
    _topView.backgroundColor = [UIColor colorWithHexString:PAGE_TOP_COLOR];
    _topView.iconImage = [UIImage imageNamed:@"icon_physical_white"];
    [_topView.rightBtn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
    _topView.title= @"车辆体检";
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    _menuView = [[UIView alloc] init];
    _menuView.backgroundColor = [UIColor colorWithHexString:NAV_BAR_COLOR];
    [self.view addSubview:_menuView];
    
    _faultCodeLabel = [[UILabel alloc] init];
    _faultCodeLabel.textAlignment = NSTextAlignmentCenter;
    _faultCodeLabel.font = [UIFont systemFontOfSize:17];
    _faultCodeLabel.textColor = [UIColor whiteColor];
    _faultCodeLabel.text = @"故障码";
    [_menuView addSubview:_faultCodeLabel];
    
    _faultDescLabel = [[UILabel alloc] init];
    _faultDescLabel.font = [UIFont systemFontOfSize:17];
    _faultDescLabel.textColor = [UIColor whiteColor];
    _faultDescLabel.text = @"故障描述";
    [_menuView addSubview:_faultDescLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@35);
    }];

    
    [_faultCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_menuView);
        make.width.equalTo(@100);
        make.height.equalTo(_menuView);
    }];
    
    
    [_faultDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView);
        make.left.equalTo(_faultCodeLabel.mas_right).offset(10);
        make.right.equalTo(_menuView);
        make.height.equalTo(_menuView);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];
    [_faultCodeLabel addRightBorderWithColor:[UIColor whiteColor] width:0.5];
    [_menuView addBottomBorderWithColor:[UIColor whiteColor] width:0.5];
}

@end
