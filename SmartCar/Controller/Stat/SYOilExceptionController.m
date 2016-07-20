//
//  SYOilExceptionController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/13.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYOilExceptionController.h"
#import "SYOilExceptionCell.h"
#import "SYPickerView.h"

@interface SYOilExceptionController () <UITableViewDataSource, UITableViewDelegate, SYPickerViewDelegate>

@property(nonatomic, strong) NSMutableArray *gasExclArray;

@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) SYPickerView *pickerView;

@property(nonatomic, strong) UIView *topNavView;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SYOilExceptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"油量异常";
    
    _gasExclArray = [[NSMutableArray alloc] init];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 24)];
    _rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [_rightButton setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(dateSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.tag = 101;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];

    
    _topNavView = [[UIView alloc] init];
    _topNavView.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    [self.view addSubview:_topNavView];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:16];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.text = @"日期";
    [_topNavView addSubview:_dateLabel];
    
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.font = [UIFont systemFontOfSize:16];
    _amountLabel.textColor = [UIColor whiteColor];
    _amountLabel.text = @"油量减少(L)";
    [_topNavView addSubview:_amountLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];

    
    [_topNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topNavView).offset(10);
        make.centerY.equalTo(_topNavView);
        make.width.equalTo(self.view).multipliedBy(0.6);
    }];
    
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dateLabel.mas_right).offset(10);
        make.centerY.equalTo(_topNavView);
        make.width.equalTo(self.view).multipliedBy(0.4);
        
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topNavView.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];


    [self requestGasAlarmWithMonth:-1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)requestGasAlarmWithMonth:(NSInteger)month {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] month:month];
    NSString *endTime = [NSDate currentDate];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:carId forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_GAS_ALARM parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        
        if (responseDic && [[responseDic objectForKey:@"GetGasAlarmResult"] integerValue] > 0) {
            NSString *tableInfoStr = [responseDic objectForKey:@"GasAlarmInfo"];
            NSDictionary *tableDic = [tableInfoStr objectFromJSONString];
            NSArray *array = [tableDic objectForKey:@"TableInfo"];
            
            [_gasExclArray removeAllObjects];
            [_gasExclArray addObjectsFromArray:array];
            [_tableView reloadData];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        [SVProgressHUD setMinimumDismissTimeInterval:2];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
}


#pragma mark - 时间切换
- (void)dateSwitchAction:(UIButton *)sender {
    if (!_pickerView) {
        _pickerView = [[SYPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64)];
        _pickerView.delegate = self;
        _pickerView.dataSourceArray = @[@"一个月内", @"三个月内", @"半年内", @"一年内"];
    }
    
    if (_pickerView.isShow) {
        [_pickerView dismiss];
    } else {
        [_pickerView showWithView:self.view];
    }
}


#pragma mark - SYDatePickerViewDelegate
- (void)pickerView:(SYPickerView *)pickerView didSelectAtIndex:(NSInteger)index {
    if (index == 0) {
        [self requestGasAlarmWithMonth:-1];
    } else if (index == 1) {
        [self requestGasAlarmWithMonth:-3];
    } else if (index == 2) {
        [self requestGasAlarmWithMonth:-6];
    } else {
        [self requestGasAlarmWithMonth:-12];
    }
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _gasExclArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SYOilExceptionCell";
    SYOilExceptionCell *gasExcCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!gasExcCell) {
        gasExcCell = [[SYOilExceptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        gasExcCell.backgroundColor = [UIColor clearColor];
    }
    
    NSString *OBDGasLevel = [_gasExclArray[indexPath.row] objectForKey:@"OBDGasLevel"];
    NSString *OBDHistoryGasLevel = [_gasExclArray[indexPath.row] objectForKey:@"OBDHistoryGasLevel"];
    CGFloat amount = ([OBDGasLevel floatValue] - [OBDHistoryGasLevel floatValue]) * [[SYAppManager sharedManager].vehicle.tankCapacity floatValue] / 100;
    
    gasExcCell.date = [_gasExclArray[indexPath.row] objectForKey:@"gpstime"];
    gasExcCell.amount = [NSString stringWithFormat:@"%.2f", amount];
    
    return gasExcCell;
}


@end
