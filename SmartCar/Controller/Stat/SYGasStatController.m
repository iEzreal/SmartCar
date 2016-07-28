//
//  SYGasStatController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/13.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYGasStatController.h"
#import "SYGasStatCell.h"
#import "SYPageTopView.h"
#import "SYPickerAlertView.h"
#import "SYGasStatDetailsController.h"

@interface SYGasStatController () <SYPageTopViewDelegate, SYPickerAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *gaslArray;

@property(nonatomic, strong) SYPickerAlertView *pickerAlertView;
@property(nonatomic, strong) SYPageTopView *topView;

@property(nonatomic, strong) UIView *menuView;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SYGasStatController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加油统计";
    
    _gaslArray = [[NSMutableArray alloc] init];
    
    [self setupPageSubviews];
    [self layoutPageSubviews];
    [self requestGasWithMonth:-1];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (SVProgressHUD.isVisible) {
        [SVProgressHUD dismiss];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 数据请求
- (void)requestGasWithMonth:(NSInteger)month {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] month:month];
    NSString *endTime = [NSDate currentDate];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:carId forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    
    [SYUtil showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_GAS_ADD parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"GetGasAddResult"] integerValue] > 0) {
            
            NSString *tableInfoStr = [responseDic objectForKey:@"GasAddInfo"];
            NSDictionary *tableDic = [tableInfoStr objectFromJSONString];
            NSArray *array = [tableDic objectForKey:@"TableInfo"];
            
            [_gaslArray removeAllObjects];
            [_gaslArray addObjectsFromArray:array];
            [_tableView reloadData];
            [SYUtil showSuccessWithStatus:@"加载数据成功" duration:1];
        } else {
            [SYUtil showSuccessWithStatus:@"加载数据失败" duration:2];
        }

    } failure:^(NSError *error) {
        [SYUtil showSuccessWithStatus:@"加载数据失败" duration:2];
    }];

}

#pragma mark - 代理事件
- (void)topViewRightAction {
    if (!_pickerAlertView) {
        _pickerAlertView = [[SYPickerAlertView alloc] initDataArray:@[@"一个月内", @"三个月内", @"半年内", @"一年内"]];
        _pickerAlertView.delegate = self;
    }
    [_pickerAlertView show];
}

- (void)pickerAlertView:(SYPickerAlertView *)pickerAlertView didSelectAtIndex:(NSInteger)index {
    if (index == 0) {
        _topView.content = @"一个月内";
        [self requestGasWithMonth:-1];
    } else if (index == 1) {
         _topView.content = @"三个月内";
        [self requestGasWithMonth:-3];
    } else if (index == 2) {
         _topView.content = @"半年内";
        [self requestGasWithMonth:-6];
    } else {
        _topView.content = @"一年内";
        [self requestGasWithMonth:-12];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _gaslArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SYGasStatCell";
    SYGasStatCell *gasStatCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!gasStatCell) {
        gasStatCell = [[SYGasStatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        gasStatCell.backgroundColor = [UIColor clearColor];
    }
    
    NSString *OBDGasLevel = [_gaslArray[indexPath.row] objectForKey:@"OBDGasLevel"];
    NSString *OBDHistoryGasLevel = [_gaslArray[indexPath.row] objectForKey:@"OBDHistoryGasLevel"];
    CGFloat amount = ([OBDGasLevel floatValue] - [OBDHistoryGasLevel floatValue]) * [[SYAppManager sharedManager].showVehicle.tankCapacity floatValue] / 100;
   
    gasStatCell.date = [_gaslArray[indexPath.row] objectForKey:@"gpstime"];
    gasStatCell.amount = [NSString stringWithFormat:@"%.2f", amount];
    
    return gasStatCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *gasTime = [_gaslArray[indexPath.row] objectForKey:@"gpstime"];
    NSString *OBDGasLevel = [_gaslArray[indexPath.row] objectForKey:@"OBDGasLevel"];
    NSString *OBDHistoryGasLevel = [_gaslArray[indexPath.row] objectForKey:@"OBDHistoryGasLevel"];
    CGFloat amount = ([OBDGasLevel floatValue] - [OBDHistoryGasLevel floatValue]) * [[SYAppManager sharedManager].showVehicle.tankCapacity floatValue] / 100;
    double lat = [[_gaslArray[indexPath.row] objectForKey:@"lat"] doubleValue];
    double lon = [[_gaslArray[indexPath.row] objectForKey:@"lon"] doubleValue];
    
    SYGasStatDetailsController *detailsController = [[SYGasStatDetailsController alloc] init];
    detailsController.titleStr = @"加油详细信息";
    detailsController.gasTime = gasTime;
    detailsController.gasAmcount = [NSString stringWithFormat:@"%.2f", amount];
    detailsController.lat = lat;
    detailsController.lon = lon;
    [self.navigationController pushViewController:detailsController animated:YES];
}

#pragma mark - 界面UI
- (void)setupPageSubviews {
    _topView = [[SYPageTopView alloc] init];
    _topView.backgroundColor = [UIColor colorWithHexString:PAGE_TOP_COLOR];
    _topView.iconImage = [UIImage imageNamed:@"icon_gas_white"];
    [_topView.rightBtn setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
    _topView.title= @"加油统计";
    _topView.content = @"一个月内";
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    _menuView = [[UIView alloc] init];
    _menuView.backgroundColor = [UIColor colorWithHexString:NAV_BAR_COLOR];
    [self.view addSubview:_menuView];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:16];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.text = @"加油日期";
    [_menuView addSubview:_dateLabel];
    
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.font = [UIFont systemFontOfSize:16];
    _amountLabel.textColor = [UIColor whiteColor];
    _amountLabel.text = @"加油量(L)";
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
