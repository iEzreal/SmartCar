//
//  SYTravelController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYTravelController.h"
#import "SYTravelDetailsController.h"
#import "SYTravelCell.h"
#import "SYTravel.h"

@interface SYTravelController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *travelLabel;
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *travelArray;

@end

@implementation SYTravelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"近期行程";
    
    _travelArray = [[NSMutableArray alloc] init];
    [self setupPageSubviews];
    [self layoutPageSubviews];
    
    [self requestCarTrip];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)homeButtonAction:(UIButton *)sender {
    
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

/**
 *  查询车辆行程信息
 */
- (void)requestCarTrip {
    NSString *termID = [SYAppManager sharedManager].vehicle.termID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:termID forKey:@"TermId"];
    [parameters setObject:@"2016-06-20 00:00:00" forKey:@"sTime"];
    [parameters setObject:@"2016-07-07 23:59:59" forKey:@"eTime"];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_CAR_TRIP parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        [self parseTravelWithJsonString:[responseDic objectForKey:@"tripInfo"]];
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}

- (void)parseTravelWithJsonString:(NSString *)jsonString {
    NSDictionary *travelDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [travelDic objectForKey:@"TableInfo"];
    for (int i = 0; i < tableArray.count; i++) {
        SYTravel *travel = [[SYTravel alloc] initWithDic:tableArray[i]];
        [_travelArray addObject:travel];
    }
    [_tableView reloadData];
}



- (void)setupPageSubviews {
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    _rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    [_rightButton setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
    //    [_rightButton setImage:[UIImage imageNamed:@"date_highlight"] forState:UIControlStateHighlighted];
    [_rightButton addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.tag = 101;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.text = @"日期";
    [self.view addSubview:_dateLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = @"时间";
    [self.view addSubview:_timeLabel];
    
    _travelLabel = [[UILabel alloc] init];
    _travelLabel.textAlignment = NSTextAlignmentCenter;
    _travelLabel.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
    _travelLabel.font = [UIFont systemFontOfSize:14];
    _travelLabel.textColor = [UIColor whiteColor];
    _travelLabel.text = @"里程";
    [self.view addSubview:_travelLabel];
    
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
