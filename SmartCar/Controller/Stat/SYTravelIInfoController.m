//
//  SYTravelIInfoController.m
//  SmartCar
//
//  Created by xxx on 16/7/14.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYTravelIInfoController.h"
#import "SYPageTopView.h"
#import "SYPickerDateView.h"

@interface SYTravelIInfoController () <SYPageTopViewDelegate, SYPickerDateViewDelegate>

@property(nonatomic, strong) SYPageTopView *pageTopView;
@property(nonatomic, strong) SYPickerDateView *datePickerView;

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UILabel *startHintLabel;
@property(nonatomic, strong) UILabel *startLabel;
@property(nonatomic, strong) UILabel *endHintLabel;
@property(nonatomic, strong) UILabel *endLabel;

@property(nonatomic, strong) UIView *centreView;
@property(nonatomic, strong) UILabel *totalOilWearHintLabel;
@property(nonatomic, strong) UILabel *totalOilWearLabel;
@property(nonatomic, strong) UILabel *avgOilWearHintLabel;
@property(nonatomic, strong) UILabel *avgOilWearLabel;
@property(nonatomic, strong) UILabel *totalMileageHintLabel;
@property(nonatomic, strong) UILabel *totalMileageLabel;

@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UILabel *speedAlarmCountHintLabel;
@property(nonatomic, strong) UILabel *speedAlarmCountLabel;
@property(nonatomic, strong) UILabel *fenceAlarmCountHintLabel;
@property(nonatomic, strong) UILabel *fenceAlarmCountLabel;
@property(nonatomic, strong) UILabel *faultAlarmCountHintLabel;
@property(nonatomic, strong) UILabel *faultAlarmCountLabel;

@property(nonatomic, strong) NSDictionary *firstDic;
@property(nonatomic, strong) NSDictionary *lastDic;
@property(nonatomic, strong) NSMutableArray *gasArray;


@end

@implementation SYTravelIInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _gasArray = [[NSMutableArray alloc] init];
    [self setupPageSubviews];
    [self layoutPageSubviews];
}

#pragma mark - 最小时间和最大时间里程和油耗
- (void)requestMinMaxPositionWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"dtTime"];
    [parameters setObject:endTime forKey:@"etTime"];
    
    __weak typeof(self) weakSelf = self;
    [SYUtil showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_MINMAX_POSITION parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if ([[responseDic objectForKey:@"GetMinAndMaxTimePositionResult"] integerValue] == 1) {
            
            NSString *firstInfo = [responseDic objectForKey:@"firstInfo"];
            NSDictionary *firstInfoDic = [firstInfo objectFromJSONString];
            NSArray *firstArray = [firstInfoDic objectForKey:@"TableInfo"];
            weakSelf.firstDic = firstArray[0];
           
            NSString *lastInfo = [responseDic objectForKey:@"lastInfo"];
            NSDictionary *lastInfoDic = [lastInfo objectFromJSONString];
            NSArray *lastArray = [lastInfoDic objectForKey:@"TableInfo"];
            weakSelf.lastDic = lastArray[0];
            
            // 加油记录
            [weakSelf requestGasWithStartTime:startTime endTime:endTime];
        } else {
            [SYUtil dismissProgressHUD];
        }
    } failure:^(NSError *error) {
       [SYUtil dismissProgressHUD];
    }];
}

#pragma mark - 加油记录
- (void)requestGasWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:carId forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    
    [SYApiServer POST:METHOD_GET_GAS_ADD parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if ([[responseDic objectForKey:@"GetGasAddResult"] integerValue] > 0) {
            NSString *tableInfoStr = [responseDic objectForKey:@"GasAddInfo"];
            NSDictionary *tableDic = [tableInfoStr objectFromJSONString];
            NSArray *array = [tableDic objectForKey:@"TableInfo"];
            
            [_gasArray removeAllObjects];
            [_gasArray addObjectsFromArray:array];
        }
        
        [self updateTravelInfo];
        [SYUtil dismissProgressHUD];
    } failure:^(NSError *error) {
       [SYUtil dismissProgressHUD];
    }];
}

#pragma mark - 警告次数
- (void)requestAlarmCountWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    [parameters setObject:[NSNumber numberWithInt:0x7FFFFFFF] forKey:@"mask"];
    
    [SYApiServer POST:METHOD_GET_ALARM_COUNT parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        [self updateAlarmCountWithDic:responseDic];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 更新数据
- (void)updateAlarmCountWithDic:(NSDictionary *)dic {
    _speedAlarmCountLabel.text = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"overspeed"] intValue]];
    _fenceAlarmCountLabel.text = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"geofence"] intValue]];
    _faultAlarmCountLabel.text = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"crash"] intValue]];
}

- (void)updateTravelInfo {
    CGFloat sumMileage = [[_lastDic objectForKey:@"Mileage"] floatValue] - [[_firstDic objectForKey:@"Mileage"] floatValue];
    sumMileage = sumMileage * 0.1;
    
    CGFloat sumOil = 0;
    CGFloat avroil = 0;
    
    CGFloat startafterlevel = [[_firstDic objectForKey:@"OBDGasLevel"] floatValue];
    for (int i = 0; i < _gasArray.count; i++) {
        CGFloat hislevel = [[_gasArray[i] objectForKey:@"OBDHistoryGasLevel"] floatValue];
        CGFloat afterlevel = [[_gasArray[i] objectForKey:@"OBDGasLevel"] floatValue];
        sumOil += (startafterlevel - hislevel) * [[SYAppManager sharedManager].showVehicle.tankCapacity floatValue] / 100;
        startafterlevel = afterlevel;
    }
    
    CGFloat nowlevel = [[_lastDic objectForKey:@"OBDGasLevel"] floatValue];
    sumOil += (startafterlevel - nowlevel) * [[SYAppManager sharedManager].showVehicle.tankCapacity floatValue] / 100;
    avroil = sumOil * 100 / sumMileage;

    _totalOilWearLabel.text = [NSString stringWithFormat:@"%.3fL", sumOil];
    _avgOilWearLabel.text = [NSString stringWithFormat:@"%.3f(100公里)", avroil];
    _totalMileageLabel.text =  [NSString stringWithFormat:@"%.3f(公里)", sumMileage];
}

#pragma mark - 代理事件
- (void)topViewRightAction {
    if (!_datePickerView) {
        _datePickerView = [[SYPickerDateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64)];
        _datePickerView.delegate = self;
    }
    [_datePickerView show];
}

- (void)datePickerView:(SYPickerDateView *)datePickerView didSelectStartMonth:(NSInteger)startMonth startDay:(NSInteger)startDay endMonth:(NSInteger)endMonth endDay:(NSInteger)endDay {
    NSInteger year = [SYUtil currentYear];
    _startLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", year, startMonth, startDay];
    _endLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", year, endMonth, endDay];
    _totalOilWearLabel.text = @"";
    _avgOilWearLabel.text = @"";
    _totalMileageLabel.text =  @"";
    _speedAlarmCountLabel.text = @"";
    _fenceAlarmCountLabel.text = @"";
    _faultAlarmCountLabel.text = @"";
    
    NSString *startDate = [NSString stringWithFormat:@"%ld-%ld-%ld 00:00:00", year, startMonth, startDay];
    NSString *endDate = [NSString stringWithFormat:@"%ld-%ld-%ld 23:59:59", year, endMonth, endDay];
    [self requestMinMaxPositionWithStartTime:startDate endTime:endDate];
    [self requestAlarmCountWithStartTime:startDate endTime:endDate];
    
}

#pragma mark - 界面UI
- (void)setupPageSubviews {
    _pageTopView = [[SYPageTopView alloc] init];
    _pageTopView.backgroundColor = [UIColor colorWithHexString:PAGE_TOP_COLOR];
    _pageTopView.iconImage = [UIImage imageNamed:@"icon_travel_white"];
    [_pageTopView.rightBtn setImage:[UIImage imageNamed:@"date_normal"] forState:UIControlStateNormal];
    _pageTopView.title= @"行驶信息";
    _pageTopView.delegate = self;
    [self.view addSubview:_pageTopView];
    
    _topView = [[UIView alloc] init];
    [self.view addSubview:_topView];
    
    _startHintLabel = [[UILabel alloc] init];
    _startHintLabel.font = [UIFont systemFontOfSize:16];
    _startHintLabel.textColor = [UIColor whiteColor];
    _startHintLabel.text = @"开始:";
    [_topView addSubview:_startHintLabel];
    
    _startLabel = [[UILabel alloc] init];
    _startLabel.font = [UIFont systemFontOfSize:16];
    _startLabel.textColor = [UIColor whiteColor];
    [_topView addSubview:_startLabel];
    
    _endHintLabel = [[UILabel alloc] init];
    _endHintLabel.font = [UIFont systemFontOfSize:16];
    _endHintLabel.textColor = [UIColor whiteColor];
    _endHintLabel.text = @"结束:";
    [_topView addSubview:_endHintLabel];
    
    _endLabel = [[UILabel alloc] init];
    _endLabel.font = [UIFont systemFontOfSize:16];
    _endLabel.textColor = [UIColor whiteColor];
    [_topView addSubview:_endLabel];
    
    
    
    _centreView = [[UIView alloc] init];
    [self.view addSubview:_centreView];
    
    _totalOilWearHintLabel = [[UILabel alloc] init];
    _totalOilWearHintLabel.font = [UIFont systemFontOfSize:16];
    _totalOilWearHintLabel.textColor = [UIColor whiteColor];
    _totalOilWearHintLabel.text = @"总油耗:";
    [_centreView addSubview:_totalOilWearHintLabel];
    
    _totalOilWearLabel = [[UILabel alloc] init];
    _totalOilWearLabel.font = [UIFont systemFontOfSize:16];
    _totalOilWearLabel.textColor = [UIColor whiteColor];
    [_centreView addSubview:_totalOilWearLabel];
    
    _avgOilWearHintLabel = [[UILabel alloc] init];
    _avgOilWearHintLabel.font = [UIFont systemFontOfSize:16];
    _avgOilWearHintLabel.textColor = [UIColor whiteColor];
    _avgOilWearHintLabel.text = @"平均油耗:";
    [_centreView addSubview:_avgOilWearHintLabel];
    
    _avgOilWearLabel = [[UILabel alloc] init];
    _avgOilWearLabel.font = [UIFont systemFontOfSize:16];
    _avgOilWearLabel.textColor = [UIColor whiteColor];
    [_centreView addSubview:_avgOilWearLabel];
    
    _totalMileageHintLabel = [[UILabel alloc] init];
    _totalMileageHintLabel.font = [UIFont systemFontOfSize:16];
    _totalMileageHintLabel.textColor = [UIColor whiteColor];
    _totalMileageHintLabel.text = @"总里程:";
    [_centreView addSubview:_totalMileageHintLabel];
    
    _totalMileageLabel = [[UILabel alloc] init];
    _totalMileageLabel.font = [UIFont systemFontOfSize:16];
    _totalMileageLabel.textColor = [UIColor whiteColor];
    [_centreView addSubview:_totalMileageLabel];
    
    
    
    
    _bottomView = [[UIView alloc] init];
    [self.view addSubview:_bottomView];
    
    _speedAlarmCountHintLabel = [[UILabel alloc] init];
    _speedAlarmCountHintLabel.font = [UIFont systemFontOfSize:16];
    _speedAlarmCountHintLabel.textColor = [UIColor whiteColor];
    _speedAlarmCountHintLabel.text = @"超速报警次数:";
    [_bottomView addSubview:_speedAlarmCountHintLabel];
    
    _speedAlarmCountLabel = [[UILabel alloc] init];
    _speedAlarmCountLabel.font = [UIFont systemFontOfSize:16];
    _speedAlarmCountLabel.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_speedAlarmCountLabel];
    
    _fenceAlarmCountHintLabel = [[UILabel alloc] init];
    _fenceAlarmCountHintLabel.font = [UIFont systemFontOfSize:16];
    _fenceAlarmCountHintLabel.textColor = [UIColor whiteColor];
    _fenceAlarmCountHintLabel.text = @"围栏报警次数:";
    [_bottomView addSubview:_fenceAlarmCountHintLabel];
    
    _fenceAlarmCountLabel = [[UILabel alloc] init];
    _fenceAlarmCountLabel.font = [UIFont systemFontOfSize:16];
    _fenceAlarmCountLabel.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_fenceAlarmCountLabel];
    
    _faultAlarmCountHintLabel = [[UILabel alloc] init];
    _faultAlarmCountHintLabel.font = [UIFont systemFontOfSize:16];
    _faultAlarmCountHintLabel.textColor = [UIColor whiteColor];
    _faultAlarmCountHintLabel.text = @"故障报警次数:";
    [_bottomView addSubview:_faultAlarmCountHintLabel];
    
    _faultAlarmCountLabel = [[UILabel alloc] init];
    _faultAlarmCountLabel.font = [UIFont systemFontOfSize:16];
    _faultAlarmCountLabel.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_faultAlarmCountLabel];

}

- (void)layoutPageSubviews {
    [_pageTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@45);
    }];

    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pageTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [_startHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView).offset(10);
        make.centerY.equalTo(_topView);
    }];
    
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_startHintLabel.mas_right).offset(10);
        make.centerY.equalTo(_topView);
    }];
    
    [_endHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(_topView);
    }];
    
    [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_endHintLabel.mas_right).offset(10);
        make.centerY.equalTo(_topView);
    }];
    
    
    
    [_centreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    [_totalOilWearHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centreView);
        make.left.equalTo(_centreView).offset(10);
        make.height.equalTo(@50);
    }];
    
    [_totalOilWearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalOilWearHintLabel);
        make.left.equalTo(_totalOilWearHintLabel.mas_right).offset(10);
        make.height.equalTo(_totalOilWearHintLabel);
    }];
    
    [_avgOilWearHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalOilWearHintLabel.mas_bottom);
        make.left.equalTo(_centreView).offset(10);
         make.height.equalTo(_totalOilWearHintLabel);
    }];
    
    [_avgOilWearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avgOilWearHintLabel);
        make.left.equalTo(_avgOilWearHintLabel.mas_right).offset(10);
        make.height.equalTo(_totalOilWearHintLabel);

    }];
    
    [_totalMileageHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avgOilWearHintLabel.mas_bottom);
        make.left.equalTo(_centreView).offset(10);
        make.height.equalTo(_totalOilWearHintLabel);
    }];
    
    [_totalMileageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalMileageHintLabel);
        make.left.equalTo(_totalMileageHintLabel.mas_right).offset(10);
        make.height.equalTo(_totalOilWearHintLabel);
        
    }];


    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centreView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    [_speedAlarmCountHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView);
        make.left.equalTo(_bottomView).offset(10);
        make.height.equalTo(@50);
    }];
    
    [_speedAlarmCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_speedAlarmCountHintLabel);
        make.left.equalTo(_speedAlarmCountHintLabel.mas_right).offset(10);
        make.height.equalTo(_speedAlarmCountHintLabel);
    }];
    
    [_fenceAlarmCountHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_speedAlarmCountHintLabel.mas_bottom);
        make.left.equalTo(_speedAlarmCountHintLabel);
        make.height.equalTo(_speedAlarmCountHintLabel);
    }];
    
    [_fenceAlarmCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fenceAlarmCountHintLabel);
        make.left.equalTo(_fenceAlarmCountHintLabel.mas_right).offset(10);
        make.height.equalTo(_fenceAlarmCountHintLabel);
        
    }];
    
    [_faultAlarmCountHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fenceAlarmCountHintLabel.mas_bottom);
        make.left.equalTo(_fenceAlarmCountHintLabel);
        make.height.equalTo(_fenceAlarmCountHintLabel);
    }];
    
    [_faultAlarmCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_faultAlarmCountHintLabel);
        make.left.equalTo(_faultAlarmCountHintLabel.mas_right).offset(10);
        make.height.equalTo(_faultAlarmCountHintLabel);
        
    }];
    
    [_topView addBottomBorderWithColor:[UIColor whiteColor] width:0.5];
    [_centreView addBottomBorderWithColor:[UIColor whiteColor] width:0.5];
    [_bottomView addBottomBorderWithColor:[UIColor whiteColor] width:0.5];
}

@end
