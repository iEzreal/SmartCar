//
//  SYTravelController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYTravelController.h"
#import "SYTravelDetailsController.h"
#import "SYPickerView.h"
#import "SYTravelCell.h"
#import "SYTravel.h"

@interface SYTravelController () <UITableViewDataSource, UITableViewDelegate, SYPickerViewDelegate>

@property(nonatomic, strong) UIButton *rightButton;

@property(nonatomic, strong) SYPickerView *pickerView;

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
    NSString *termID = [SYAppManager sharedManager].vehicle.termID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] month:month];
    NSString *endTime = [NSDate currentDate];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:termID forKey:@"TermId"];
    [parameters setObject:startTime forKey:@"sTime"];
    [parameters setObject:endTime forKey:@"eTime"];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_CAR_TRIP parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"GetCarTripResult"] integerValue] > 0) {
            [self parseTravelWithJsonString:[responseDic objectForKey:@"tripInfo"]];
        } else {
            [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
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

#pragma mark - 代理方法
- (void)pickerView:(SYPickerView *)pickerView didSelectAtIndex:(NSInteger)index {
    if (index == 0) {
        [self requestTravelWithMonth:-1];
    } else if (index == 1) {
        [self requestTravelWithMonth:-3];
    } else if (index == 2) {
        [self requestTravelWithMonth:-6];
    } else {
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
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    _rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    [_rightButton setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(dateSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.tag = 101;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _dateLabel.font = [UIFont systemFontOfSize:16];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.text = @"日期";
    [self.view addSubview:_dateLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = @"时间";
    [self.view addSubview:_timeLabel]; 
    
    _travelLabel = [[UILabel alloc] init];
    _travelLabel.textAlignment = NSTextAlignmentCenter;
    _travelLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _travelLabel.font = [UIFont systemFontOfSize:16];
    _travelLabel.textColor = [UIColor whiteColor];
    _travelLabel.text = @"里程";
    [self.view addSubview:_travelLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (void)layoutPageSubviews {
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(@40);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateLabel);
        make.left.equalTo(_dateLabel.mas_right);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(_dateLabel);
    }];
    
    [_travelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateLabel);
        make.left.equalTo(_timeLabel.mas_right);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(_dateLabel);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateLabel.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];
}


@end
