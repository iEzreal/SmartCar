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

@interface SYPhysicalController () <SYPageTopViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) SYPageTopView *topView;
@property(nonatomic, strong) UIView *menuView;
@property(nonatomic, strong) UILabel *faultCodeLabel;
@property(nonatomic, strong) UILabel *faultDescLabel;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *physicalArray;

@end

@implementation SYPhysicalController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _physicalArray = [[NSMutableArray alloc] init];
    [self setupPageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 数据请求
- (void)getDtcCode {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSString *termId = [SYAppManager sharedManager].vehicle.termID;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"uCarId"];
    [parameters setObject:termId forKey:@"szTermId"];
    [parameters setObject:[NSNumber numberWithInt:5000] forKey:@"nTimeOut"];
    
    [SYUtil showWithStatus:@"正在体检..."];
    [SYApiServer OBD_POST:METHOD_GET_DTC_CODE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if ([[responseDic objectForKey:@"GetDtcCodeResult"] intValue] > 0) {
            [self dtcTranslate:@""];
        } else {
            [SYUtil showErrorWithStatus:@"体检失败" duration:2];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"体检失败" duration:2];
    }];
}

- (void)dtcTranslate:(NSString *)dtcCode {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:dtcCode forKey:@"dtc"];
    [SYApiServer POST:METHOD_DTC_TRANSLATE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if ([[responseDic objectForKey:@"GetDtcCodeResult"] intValue] > 0) {
            
            
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
    return _physicalArray.count;
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
//    physicalCell.faultCode = @"test";
//    physicalCell.faultDesc = @"testtestetsetstetste";
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
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
