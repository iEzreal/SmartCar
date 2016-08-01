//
//  SYTravelController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYTravelController.h"
#import "SYTravelDetailsController.h"
#import "SYPageTopView.h"
#import "SYPickerAlertView.h"
#import "SYTravelCell.h"
#import "SYTravel.h"

@interface SYTravelController () <UITableViewDataSource, UITableViewDelegate, SYPageTopViewDelegate, SYPickerAlertViewDelegate>

@property(nonatomic, strong) SYPickerAlertView *pickerAlertView;

@property(nonatomic, strong) SYPageTopView *topView;

@property(nonatomic, strong) UIView *menuView;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *travelLabel;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *travelArray;

@end

@implementation SYTravelController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"近期行程";
    
    _travelArray = [[NSMutableArray alloc] init];
    [self setupPageSubviews];
    [self layoutPageSubviews];
    [self requestTravelWithMonth:-1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 查询车辆行程信息
- (void)requestTravelWithMonth:(NSInteger)month {
    NSString *termID = [SYAppManager sharedManager].showVehicle.termID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] month:month];
    NSString *endTime = [NSDate currentDate];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:termID forKey:@"TermId"];
    [parameters setObject:startTime forKey:@"sTime"];
    [parameters setObject:endTime forKey:@"eTime"];
    
    [SYUtil showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_CAR_TRIP parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"GetCarTripResult"] integerValue] > 0) {
            [self parseTravelWithJsonString:[responseDic objectForKey:@"tripInfo"]];
            [SYUtil showSuccessWithStatus:@"加载数据成功" duration:1];
        } else {
            [SYUtil showErrorWithStatus:@"加载数据失败" duration:2];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"加载数据失败" duration:2];
    }];
}

- (void)parseTravelWithJsonString:(NSString *)jsonString {
    NSDictionary *travelDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [travelDic objectForKey:@"TableInfo"];
    [_travelArray removeAllObjects];
    for (int i = 0; i < tableArray.count; i++) {
        SYTravel *travel = [[SYTravel alloc] initWithDic:tableArray[i]];
        [_travelArray addObject:travel];
    }
    [_tableView reloadData];
}

#pragma mark - 点击事件处理
- (void)dateSwitchAction:(UIButton *)sender {
    }

#pragma mark - 代理方法
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
        [self requestTravelWithMonth:-1];
        
    } else if (index == 1) {
        _topView.content = @"三个月内";
        [self requestTravelWithMonth:-3];
        
    } else if (index == 2) {
        _topView.content = @"半年内";
        [self requestTravelWithMonth:-6];
        
    } else {
        _topView.content = @"一年内";
        [self requestTravelWithMonth:-12];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _travelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SYTravelCell";
    SYTravelCell *travelCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!travelCell) {
        travelCell = [[SYTravelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        travelCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        travelCell.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    }
    
    [travelCell setTravelInfo:_travelArray[indexPath.row]];
    return travelCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SYTravelDetailsController *dController = [[SYTravelDetailsController alloc] init];
    dController.travel = _travelArray[indexPath.row];
    [self.navigationController pushViewController:dController animated:YES];
}

#pragma mark - 界面UI
- (void)setupPageSubviews {
    _topView = [[SYPageTopView alloc] init];
    _topView.backgroundColor = [UIColor colorWithHexString:PAGE_TOP_COLOR];
    _topView.iconImage = [UIImage imageNamed:@"icon_travel_white"];
    [_topView.rightBtn setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
    _topView.title= @"近期行程";
    _topView.content = @"一个月内";
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    _menuView = [[UIView alloc] init];
    _menuView.backgroundColor = [UIColor colorWithHexString:NAV_BAR_COLOR];
    [self.view addSubview:_menuView];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:17];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.text = @"日期";
    [_menuView addSubview:_dateLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:17];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = @"时间";
    [_menuView addSubview:_timeLabel];
    
    _travelLabel = [[UILabel alloc] init];
    _travelLabel.textAlignment = NSTextAlignmentCenter;
    _travelLabel.font = [UIFont systemFontOfSize:17];
    _travelLabel.textColor = [UIColor whiteColor];
    _travelLabel.text = @"里程";
    [_menuView addSubview:_travelLabel];
    
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
        make.top.equalTo(_menuView);
        make.left.equalTo(_menuView);
        make.width.equalTo(@(SCREEN_W / 3));
        make.height.equalTo(_menuView);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView);
        make.left.equalTo(_dateLabel.mas_right);
        make.width.equalTo(_dateLabel);
        make.height.equalTo(_menuView);
    }];
    
    [_travelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView);
        make.left.equalTo(_timeLabel.mas_right);
        make.width.equalTo(_dateLabel);
        make.height.equalTo(_menuView);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-64 - 49);
    }];
    
    [_timeLabel addLeftBorderWithColor:[UIColor whiteColor] width:0.5];
    [_timeLabel addRightBorderWithColor:[UIColor whiteColor] width:0.5];
}


@end
