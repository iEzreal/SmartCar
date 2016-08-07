//
//  SYAlarmStatController.m
//  SmartCar
//
//  Created by liuyiming on 16/7/20.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYAlarmStatController.h"
#import "SYAlarmStatCell.h"
#import "SYPageTopView.h"
#import "SYPickerAlertView.h"

@interface SYAlarmStatController () <SYPageTopViewDelegate, SYPickerAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) SYPickerAlertView *pickerAlertView;
@property(nonatomic, strong) SYPageTopView *topView;

@property(nonatomic, strong) UIView *menuView;
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
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] month:month];
    NSString *endTime = [NSDate currentDate];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    [parameters setObject:[NSNumber numberWithInt:0x7FFFFFFF] forKey:@"mask"];
    
    [SYUtil showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_ALARM_COUNT parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic) {
            _alarmDic = [[NSDictionary alloc] initWithDictionary:responseDic];
            [_tableView reloadData];
            [SYUtil dismissProgressHUD];
        } else {
            [SYUtil showErrorWithStatus:@"数据加载失败" duration:2];
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
        [self requestAlarmWithMonth:-1];
    } else if (index == 1) {
        _topView.content = @"三个月内";
        [self requestAlarmWithMonth:-3];
    } else if (index == 2) {
        _topView.content = @"半年内";
        [self requestAlarmWithMonth:-6];
    } else {
        _topView.content = @"一年内";
        [self requestAlarmWithMonth:-12];
    }
}

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
        alarmCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    _topView = [[SYPageTopView alloc] init];
    _topView.backgroundColor = [UIColor colorWithHexString:PAGE_TOP_COLOR];
    _topView.iconImage = [UIImage imageNamed:@"icon_alarm_white"];
    [_topView.rightBtn setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
    _topView.title= @"报警统计";
    _topView.content = @"一个月内";
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    _menuView = [[UIView alloc] init];
    _menuView.backgroundColor = [UIColor colorWithHexString:NAV_BAR_COLOR];
    [self.view addSubview:_menuView];

    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.font = [UIFont systemFontOfSize:16];
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.text = @"类型";
    [_menuView addSubview:_typeLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = [UIFont systemFontOfSize:16];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.text = @"次数";
    [_menuView addSubview:_countLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.font = [UIFont systemFontOfSize:16];
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.text = @"描述";
    [_menuView addSubview:_descLabel];
    
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

    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView);
        make.left.equalTo(_menuView);
        make.width.equalTo(_menuView).dividedBy(3);
        make.height.equalTo(_menuView);

    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView);
        make.left.equalTo(_typeLabel.mas_right);
        make.width.equalTo(_menuView).dividedBy(6);
        make.height.equalTo(_menuView);

    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView);
        make.left.equalTo(_countLabel.mas_right);
        make.width.equalTo(_menuView).dividedBy(2);
        make.height.equalTo(_menuView);

    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-64-49);
    }];
    
    [_countLabel addLeftBorderWithColor:[UIColor whiteColor] width:0.5];
    [_countLabel addRightBorderWithColor:[UIColor whiteColor] width:0.5];
}


@end
