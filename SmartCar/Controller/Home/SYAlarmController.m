//
//  SYAlarmController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYAlarmController.h"
#import "SYAlarmCell.h"
#import "SYAlarm.h"

@interface SYAlarmController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UILabel *typeLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *valuelLabel;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *alarmArray;

@end

@implementation SYAlarmController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"近期警报";
    
    _alarmArray = [[NSMutableArray alloc] init];
    
    [self setupPageSubviews];
    [self layoutPageSubviews];
    
    [self requestAlarmInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 请求车辆行程信息
- (void)requestAlarmInfo {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"CarId"];
    [parameters setObject:@"2016-07-01 00:00:00" forKey:@"StartTime"];
    [parameters setObject:@"2016-07-07 23:59:59" forKey:@"EndTime"];
    [parameters setObject:[NSNumber numberWithInt:0x7FFFFFFF] forKey:@"mask"];

    [SVProgressHUD showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_ALARM_INFO parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        NSString *alarmStr = [responseDic objectForKey:@"AlarmInfo"];
        NSDictionary *alarmDic = [alarmStr objectFromJSONString];
        NSArray *alarmArray = [alarmDic objectForKey:@"TableInfo"];
        for (int i = 0; i < alarmArray.count; i++){
            SYAlarm *alarm = [[SYAlarm alloc] initWithDic:alarmArray[i]];
            [_alarmArray addObject:alarm];
        }
        
        [_tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _alarmArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SYAlarmCell";
    SYAlarmCell *alarmCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!alarmCell) {
        alarmCell = [[SYAlarmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        alarmCell.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
        alarmCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [alarmCell boundDataWithAlarm:_alarmArray[indexPath.row]];
    return alarmCell;
}

#pragma mark - 页面View
- (void)setupPageSubviews {
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _typeLabel.font = [UIFont systemFontOfSize:16];
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.text = @"报警类型";
    [self.view addSubview:_typeLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = @"时间";
    [self.view addSubview:_timeLabel];
    
    _valuelLabel = [[UILabel alloc] init];
    _valuelLabel.textAlignment = NSTextAlignmentCenter;
    _valuelLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _valuelLabel.font = [UIFont systemFontOfSize:16];
    _valuelLabel.textColor = [UIColor whiteColor];
    _valuelLabel.text = @"报警值";
    [self.view addSubview:_valuelLabel];
    
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
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(@40);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel);
        make.left.equalTo(_typeLabel.mas_right);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(_typeLabel);
    }];
    
    [_valuelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel);
        make.left.equalTo(_timeLabel.mas_right);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(_typeLabel);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];

    
}


@end
