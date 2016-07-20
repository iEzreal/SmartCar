//
//  SYGasStatController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/13.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYGasStatController.h"
#import "SYGasStatCell.h"
#import "SYPickerView.h"
#import "SYGasStatDetailsController.h"
@interface SYGasStatController () <UITableViewDataSource, UITableViewDelegate, SYPickerViewDelegate>

@property(nonatomic, strong) NSMutableArray *gaslArray;

@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) SYPickerView *pickerView;

@property(nonatomic, strong) UIView *topNavView;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SYGasStatController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加油统计";
    
    _gaslArray = [[NSMutableArray alloc] init];
    
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
    _dateLabel.text = @"加油日期";
    [_topNavView addSubview:_dateLabel];
    
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.font = [UIFont systemFontOfSize:16];
    _amountLabel.textColor = [UIColor whiteColor];
    _amountLabel.text = @"加油量(L)";
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
        make.height.equalTo(@40);
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

- (void)requestGasWithMonth:(NSInteger)month {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] month:month];
    NSString *endTime = [NSDate currentDate];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:carId forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
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

        }
    [SVProgressHUD dismiss];

    } failure:^(NSError *error) {
        [SVProgressHUD setMinimumDismissTimeInterval:2];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];

}


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

#pragma mark -
- (void)pickerView:(SYPickerView *)pickerView didSelectAtIndex:(NSInteger)index {
    if (index == 0) {
        [self requestGasWithMonth:-1];
    } else if (index == 1) {
        [self requestGasWithMonth:-3];
    } else if (index == 2) {
        [self requestGasWithMonth:-6];
    } else {
        [self requestGasWithMonth:-12];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
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
    CGFloat amount = ([OBDGasLevel floatValue] - [OBDHistoryGasLevel floatValue]) * [[SYAppManager sharedManager].vehicle.tankCapacity floatValue] / 100;
   
    gasStatCell.date = [_gaslArray[indexPath.row] objectForKey:@"gpstime"];
    gasStatCell.amount = [NSString stringWithFormat:@"%.2f", amount];
    
    return gasStatCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SYGasStatDetailsController *detailsController = [[SYGasStatDetailsController alloc] init];
    detailsController.gasDic = _gaslArray[indexPath.row];
    [self.navigationController pushViewController:detailsController animated:YES];
}


@end
