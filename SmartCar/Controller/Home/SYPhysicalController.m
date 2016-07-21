//
//  SYPhysicalController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/8.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYPhysicalController.h"
#import "SYPhysicalCell.h"

@interface SYPhysicalController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *physicalArray;

@end

@implementation SYPhysicalController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    self.title = @"车辆体检";
    
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

#pragma mark - 点击事件处理
- (void)physicalAction:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"使用该功能，请确保您的车处于停止行驶状态，否则可能发生危险!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

#pragma mark - 代理方法
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
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    [rightButton setImage:[UIImage imageNamed:@"check_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(physicalAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = 101;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    [self.view addSubview:titleView];
    
    UILabel *faultCodeLabel = [[UILabel alloc] init];
    faultCodeLabel.textAlignment = NSTextAlignmentCenter;
    faultCodeLabel.font = [UIFont systemFontOfSize:17];
    faultCodeLabel.textColor = [UIColor whiteColor];
    faultCodeLabel.text = @"故障码";
    [titleView addSubview:faultCodeLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:lineView];
    
    UILabel *faultDescLabel = [[UILabel alloc] init];
    faultDescLabel.font = [UIFont systemFontOfSize:17];
    faultDescLabel.textColor = [UIColor whiteColor];
    faultDescLabel.text = @"故障描述";
    [titleView addSubview:faultDescLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    [faultCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView);
        make.centerY.equalTo(titleView);
        make.width.equalTo(@100);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(faultCodeLabel.mas_right);
        make.centerY.equalTo(titleView);
        make.width.equalTo(@0.5);
        make.height.equalTo(@25);
    }];
    
    [faultDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(10);
        make.right.equalTo(titleView);
        make.centerY.equalTo(titleView);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];
}

@end
