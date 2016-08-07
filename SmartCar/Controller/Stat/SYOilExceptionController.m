//
//  SYOilExceptionController.m
//  SmartCar
//
//  Created by liuyiming on 16/7/13.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYOilExceptionController.h"
#import "SYGasStatDetailsController.h"
#import "SYOilExceptionCell.h"
#import "SYPageTopView.h"
#import "SYPickerAlertView.h"

@interface SYOilExceptionController () <SYPageTopViewDelegate, SYPickerAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *gasExclArray;

@property(nonatomic, strong) SYPickerAlertView *pickerAlertView;
@property(nonatomic, strong) SYPageTopView *topView;

@property(nonatomic, strong) UIView *menuView;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SYOilExceptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"油量异常";
    
    _gasExclArray = [[NSMutableArray alloc] init];
    [self setupPageSubviews];
    [self layoutPageSubviews];
    [self requestGasAlarmWithMonth:-1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 异常记录请求
- (void)requestGasAlarmWithMonth:(NSInteger)month {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] month:month];
    NSString *endTime = [NSDate currentDate];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:carId forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    
    [SYUtil showWithStatus:@"正在加载..."];
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
            [SYUtil dismissProgressHUD];
        } else {
            [SYUtil dismissProgressHUD];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"数据加载失败" duration:2];
    }];
}

#pragma mark - 代理事件
- (void)topViewRightAction {
    if (!_pickerAlertView) {
        _pickerAlertView = [[SYPickerAlertView alloc] initWithTitle:@"日期选择" dataArray:@[@"一个月内", @"三个月内", @"半年内", @"一年内"]];
        _pickerAlertView.delegate = self;
    }
    [_pickerAlertView show];
}

- (void)pickerAlertView:(SYPickerAlertView *)pickerAlertView didSelectAtIndex:(NSInteger)index {
    if (index == 0) {
        _topView.content = @"一个月内";
        [self requestGasAlarmWithMonth:-1];
    } else if (index == 1) {
        _topView.content = @"三个月内";
        [self requestGasAlarmWithMonth:-3];
    } else if (index == 2) {
        _topView.content = @"半年内";
        [self requestGasAlarmWithMonth:-6];
    } else {
        _topView.content = @"一年内";
        [self requestGasAlarmWithMonth:-12];
    }
}

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
    CGFloat amount = ([OBDGasLevel floatValue] - [OBDHistoryGasLevel floatValue]) * [[SYAppManager sharedManager].showVehicle.tankCapacity floatValue] / 100;
    
    gasExcCell.date = [_gasExclArray[indexPath.row] objectForKey:@"gpstime"];
    gasExcCell.amount = [NSString stringWithFormat:@"%.2f", amount];
    
    return gasExcCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *gasTime = [_gasExclArray[indexPath.row] objectForKey:@"gpstime"];
    NSString *OBDGasLevel = [_gasExclArray[indexPath.row] objectForKey:@"OBDGasLevel"];
    NSString *OBDHistoryGasLevel = [_gasExclArray[indexPath.row] objectForKey:@"OBDHistoryGasLevel"];
    CGFloat amount = ([OBDGasLevel floatValue] - [OBDHistoryGasLevel floatValue]) * [[SYAppManager sharedManager].showVehicle.tankCapacity floatValue] / 100;
    double lat = [[_gasExclArray[indexPath.row] objectForKey:@"lat"] doubleValue];
    double lon = [[_gasExclArray[indexPath.row] objectForKey:@"lon"] doubleValue];;
    
    SYGasStatDetailsController *detailsController = [[SYGasStatDetailsController alloc] init];
    detailsController.titleStr = @"加油详细信息";
    detailsController.gasTime = gasTime;
    detailsController.gasAmcount = [NSString stringWithFormat:@"%.2f", amount];
    detailsController.lat = lat;
    detailsController.lon = lon;
    [self.navigationController pushViewController:detailsController animated:YES];
}

#pragma mark -界面UI
- (void)setupPageSubviews {
    _topView = [[SYPageTopView alloc] init];
    _topView.backgroundColor = [UIColor colorWithHexString:PAGE_TOP_COLOR];
    _topView.iconImage = [UIImage imageNamed:@"icon_gas_exc"];
    [_topView.rightBtn setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
    _topView.title= @"油量异常";
    _topView.content = @"一个月内";
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    _menuView = [[UIView alloc] init];
    _menuView.backgroundColor = [UIColor colorWithHexString:NAV_BAR_COLOR];
    [self.view addSubview:_menuView];
    
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:16];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.text = @"日期";
    [_menuView addSubview:_dateLabel];
    
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.font = [UIFont systemFontOfSize:16];
    _amountLabel.textColor = [UIColor whiteColor];
    _amountLabel.text = @"油量减少(L)";
    [_menuView addSubview:_amountLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (void)layoutPageSubviews {
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@35);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_menuView).offset(10);
        make.centerY.equalTo(_menuView);
        make.width.equalTo(self.view).multipliedBy(0.6);
    }];
    
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dateLabel.mas_right).offset(10);
        make.centerY.equalTo(_menuView);
        make.width.equalTo(self.view).multipliedBy(0.4);
        
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-64-49);
    }];
}

@end
