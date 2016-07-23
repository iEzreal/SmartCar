//
//  SYAlarmController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYAlarmController.h"
#import "SYPageTopView.h"
#import "SYAlarmCell.h"
#import "SYAlarm.h"

@interface SYAlarmController () <SYPageTopViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) SYPageTopView *topView;

@property(nonatomic, strong) UIView *menuView;
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


#pragma mark - 请求警告信息
- (void)requestAlarmInfo {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] month:-1];
    NSString *endTime = [NSDate currentDate];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    [parameters setObject:[NSNumber numberWithInt:0x7FFFFFFF] forKey:@"mask"];

    [SYUtil showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_ALARM_INFO parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"GetAlarmInfoResult"] integerValue] > 0) {
            NSString *alarmStr = [responseDic objectForKey:@"AlarmInfo"];
            NSDictionary *alarmDic = [alarmStr objectFromJSONString];
            NSArray *alarmArray = [alarmDic objectForKey:@"TableInfo"];
            for (int i = 0; i < alarmArray.count; i++){
                SYAlarm *alarm = [[SYAlarm alloc] initWithDic:alarmArray[i]];
                [_alarmArray addObject:alarm];
            }
            [_tableView reloadData];
            [SYUtil showSuccessWithStatus:@"数据加载成功" duration:1];
        } else {
            [SYUtil showErrorWithStatus:@"数据加载失败" duration:2];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"数据加载失败" duration:2];
    }];
}

#pragma mark - 代理方法
- (void)topViewRightAction {

}

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

#pragma mark - 页面UI
- (void)setupPageSubviews {
    _topView = [[SYPageTopView alloc] init];
    _topView.backgroundColor = [UIColor colorWithHexString:PAGE_TOP_COLOR];
    _topView.iconImage = [UIImage imageNamed:@"icon_travel_white"];
    [_topView.rightBtn setImage:[UIImage imageNamed:@"icon_alarm_del"] forState:UIControlStateNormal];
    _topView.title= @"近期警报";
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    _menuView = [[UIView alloc] init];
    _menuView.backgroundColor = [UIColor colorWithHexString:NAV_BAR_COLOR];
    [self.view addSubview:_menuView];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.font = [UIFont systemFontOfSize:17];
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.text = @"报警类型";
    [_menuView addSubview:_typeLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:17];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = @"时间";
    [_menuView addSubview:_timeLabel];
    
    _valuelLabel = [[UILabel alloc] init];
    _valuelLabel.textAlignment = NSTextAlignmentCenter;
    _valuelLabel.font = [UIFont systemFontOfSize:17];
    _valuelLabel.textColor = [UIColor whiteColor];
    _valuelLabel.text = @"报警值";
    [_menuView addSubview:_valuelLabel];
    
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
        make.left.top.equalTo(_menuView);
        make.width.equalTo(@(SCREEN_W / 3));
        make.height.equalTo(_menuView);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView);
        make.left.equalTo(_typeLabel.mas_right);
        make.width.equalTo(@(SCREEN_W / 3));
        make.height.equalTo(_menuView);
    }];
    
    [_valuelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView);
        make.left.equalTo(_timeLabel.mas_right);
        make.width.equalTo(@(SCREEN_W / 3));
        make.height.equalTo(_menuView);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];
    
    [_timeLabel addLeftBorderWithColor:[UIColor whiteColor] width:0.5];
    [_timeLabel addRightBorderWithColor:[UIColor whiteColor] width:0.5];
}


@end
