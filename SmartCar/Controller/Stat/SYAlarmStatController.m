//
//  SYAlarmStatController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/20.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYAlarmStatController.h"
#import "SYAlarmStatCell.h"
#import "SYPickerView.h"

@interface SYAlarmStatController () <UITableViewDataSource, UITableViewDelegate, SYPickerViewDelegate>

@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) SYPickerView *pickerView;

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UILabel *typeLabel;
@property(nonatomic, strong) UILabel *countLabel;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *alarmArray;
@property(nonatomic, strong) NSArray *descArray;
@property(nonatomic, strong) NSDictionary *alarmDic;

@end

@implementation SYAlarmStatController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警统计";
    
    _alarmArray = @[@"超速报警", @"转速速报警", @"发动机异常", @"水温报警",
                    @"震动报警", @"电子围栏报警", @"低电压报警", @"油压报警"];
    
    _descArray = @[@"速度超过100公里", @"发动机转速超过5000", @"发动机其他异常", @"发动机水温过高",
                   @"车辆可能发生碰撞", @"进出电子围栏", @"电池电压过低", @"油压异常",];
    
    [self setupPageSubviews];
    [self layoutPageSubviews];
    
     [self requestAlarmWithMonth:-1];
}

#pragma mark - 加载警告
- (void)requestAlarmWithMonth:(NSInteger)month {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] month:month];
    NSString *endTime = [NSDate currentDate];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    [parameters setObject:[NSNumber numberWithInt:0x7FFFFFFF] forKey:@"mask"];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_ALARM_COUNT parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic) {
            _alarmDic = [[NSDictionary alloc] initWithDictionary:responseDic];
            [_tableView reloadData];
            
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD setMinimumDismissTimeInterval:2];
            [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD setMinimumDismissTimeInterval:2];
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}

#pragma mark - 日期事件
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

#pragma mark - 日期选择代理
- (void)pickerView:(SYPickerView *)pickerView didSelectAtIndex:(NSInteger)index {
    if (index == 0) {
        [self requestAlarmWithMonth:-1];
    } else if (index == 1) {
        [self requestAlarmWithMonth:-3];
    } else if (index == 2) {
        [self requestAlarmWithMonth:-6];
    } else {
        [self requestAlarmWithMonth:-12];
    }
}

#pragma mark - UITableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _alarmArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SYAlarmStatCell";
    SYAlarmStatCell *alarmCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!alarmCell) {
        alarmCell = [[SYAlarmStatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        alarmCell.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    }
    
    alarmCell.typeLabel.text = _alarmArray[indexPath.row];
    alarmCell.descLabel.text = _descArray[indexPath.row];
    if (_alarmDic) {
        if (indexPath.row == 0) {
            alarmCell.countLabel.text = [NSString stringWithFormat:@"%@", [_alarmDic objectForKey:@"overspeed"]] ;
            
        } else if (indexPath.row == 1) {
            alarmCell.countLabel.text = [NSString stringWithFormat:@"%@", [_alarmDic objectForKey:@"overrpm"]] ;
            
        } else if (indexPath.row == 2) {
            alarmCell.countLabel.text = [NSString stringWithFormat:@"%@", [_alarmDic objectForKey:@"mil"]] ;
            
            
        } else if (indexPath.row == 3) {
            alarmCell.countLabel.text = [NSString stringWithFormat:@"%@", [_alarmDic objectForKey:@"overtemp"]] ;
            
            
        } else if (indexPath.row == 4) {
            alarmCell.countLabel.text = [NSString stringWithFormat:@"%@", [_alarmDic objectForKey:@"crash"]] ;
            
        } else if (indexPath.row == 5) {
            alarmCell.countLabel.text = [NSString stringWithFormat:@"%@", [_alarmDic objectForKey:@"geofence"]] ;
            
            
        } else if (indexPath.row == 6) {
            alarmCell.countLabel.text = [NSString stringWithFormat:@"%@", [_alarmDic objectForKey:@"lowbatt"]] ;
            
            
        } else if (indexPath.row == 7) {
            alarmCell.countLabel.text = [NSString stringWithFormat:@"%@", [_alarmDic objectForKey:@"lowgaslevel"]] ;
        }
    }
    
    return alarmCell;
}

#pragma mark - 页面UI
- (void)setupPageSubviews {
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    _rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    [_rightButton setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(dateSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.tag = 101;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    [self.view addSubview:_topView];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.font = [UIFont systemFontOfSize:16];
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.text = @"类型";
    [_topView addSubview:_typeLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = [UIFont systemFontOfSize:16];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.text = @"次数";
    [_topView addSubview:_countLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.font = [UIFont systemFontOfSize:16];
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.text = @"描述";
    [_topView addSubview:_descLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (void)layoutPageSubviews {
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(5);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(_topView);

    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(_typeLabel.mas_right).offset(5);
        make.width.equalTo(self.view).dividedBy(6);
        make.height.equalTo(_topView);

    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(_countLabel.mas_right).offset(5);
        make.width.equalTo(self.view).dividedBy(2);
        make.height.equalTo(_topView);

    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];
}


@end
