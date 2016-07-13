//
//  SYHomeController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeController.h"
#import "SYTravelController.h"
#import "SYCurrentLocationController.h"
#import "SYAlarmController.h"
#import "SYPhysicalController.h"

#import "SYCarSwitchView.h"
#import "SYHomeCarGaugeView.h"
#import "SYLatestTravelCell.h"
#import "SYHomeMenuCell.h"
#import "SYLatestTravelHeaderView.h"

#import "SYVehiclePosition.h"
#import "SYTravel.h"

@interface SYHomeController () <UITableViewDataSource, UITableViewDelegate, SYCarSwitchViewDelegate>

@property(nonatomic, strong) SYButton *navTitleBtn;
@property(nonatomic, strong) SYButton *locationBtn;

@property(nonatomic, strong) SYCarSwitchView *carSwitchView;
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) SYHomeCarGaugeView *carGaugeView;
@property(nonatomic, strong) SYLatestTravelHeaderView *travelHeaderView;

@property(nonatomic, strong) SYVehiclePosition *vePosition;
@property(nonatomic, strong) NSMutableArray *travelArray;

@end

@implementation SYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.titleView = self.navTitleBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.locationBtn];
    
    _travelArray = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
    
    [self requestCarLastPosition];
    [self requestCarTrip];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 数据请求
/**
 *  获取车辆最后位置信息
 */
- (void)requestCarLastPosition {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:carId forKey:@"CarId"];
    [SYApiServer POST:METHOD_GET_LAST_POSITION parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        [self parseVehickePositionWithJsonString:[responseDic objectForKey:@"PositionInfo"]];
        
        [self.carGaugeView endRefresh];
        
    } failure:^(NSError *error) {
        [self.carGaugeView endRefresh];
    }];
}
/**
 *  查询车辆行程信息
 */
- (void)requestCarTrip {
    NSString *termID = [SYAppManager sharedManager].vehicle.termID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:termID forKey:@"TermId"];
    [parameters setObject:@"2016-7-01 00:00:00" forKey:@"sTime"];
    [parameters setObject:@"2016-07-05 23:59:59" forKey:@"eTime"];
    
    [SYApiServer POST:METHOD_GET_CAR_TRIP parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        [self parseTravelWithJsonString:[responseDic objectForKey:@"tripInfo"]];
        
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


- (void)parseVehickePositionWithJsonString:(NSString *)jsonString {
    NSDictionary *positionDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [positionDic objectForKey:@"TableInfo"];
    NSDictionary *dic = tableArray[0];
    
    _vePosition = [[SYVehiclePosition alloc] initWithDic:dic];
    _carGaugeView.refreshTimeText = _vePosition.recvTime;
    _carGaugeView.oilText = _vePosition.OBDGasLevel;
    _carGaugeView.speedText = _vePosition.OBDSpeed;
    _carGaugeView.stateText = _vePosition.engineOnOff;
    _carGaugeView.voltageText = _vePosition.OBDBatt;
    _carGaugeView.mileageText = _vePosition.mileage;
    
    // 刷新地图位置
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_travelArray.count <= 5) {
            return _travelArray.count;
        } else {
            return 5;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (!_travelHeaderView) {
            _travelHeaderView = [[SYLatestTravelHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
            _travelHeaderView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
        }
        WeakSelf;
        _travelHeaderView.block = ^(){
            SYTravelController *travelController = [[SYTravelController alloc] init];
            travelController.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:travelController animated:YES];
        };
        
        return _travelHeaderView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return SCREEN_W / 2;
    }
    
    return 28;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier = @"SYLatestTravelCell";
        SYLatestTravelCell *travelCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!travelCell) {
            travelCell = [[SYLatestTravelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            travelCell.selectionStyle = UITableViewCellSelectionStyleNone;
            travelCell.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
        }
       
        [travelCell setTravelInfo:_travelArray[indexPath.row]];
        return travelCell;

    } else {
        static NSString *identifier = @"SYHomeMenuCell";
        SYHomeMenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!menuCell) {
            menuCell = [[SYHomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
            menuCell.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
        }
        WeakSelf;
        menuCell.block = ^(NSInteger index){
            if (index == 0) {
                SYCurrentLocationController *locationController = [[SYCurrentLocationController alloc] init];
                locationController.lat = _vePosition.lat;
                locationController.lon = _vePosition.lon;
                [weakSelf.navigationController pushViewController:locationController animated:YES];
                
            } else if (index == 1) {
                SYAlarmController *alarmController = [[SYAlarmController alloc] init];
                alarmController.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:alarmController animated:YES];
               
            } else {
                SYPhysicalController *physicalController = [[SYPhysicalController alloc] init];
                physicalController.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:physicalController animated:YES];
            }
        };
        
        if (_vePosition) {
            [menuCell setMapPointWithLat:[_vePosition.lat doubleValue] lon:[_vePosition.lon doubleValue]];
        }
        
        return menuCell;
    }
}


#pragma mark - SYCarSwitchViewDelegate
- (void)carSwitchView:(SYCarSwitchView *)carSwitchView didSelectRowAtIndex:(NSInteger)index {
    
    NSLog(@"-----------%ld", (long)index);
}


#pragma mark - 按钮点击事件
- (void)homeButtonAction:(UIButton *)sender {
    if (sender.tag == 100) {
        if (!_carSwitchView) {
            _carSwitchView = [[SYCarSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
            _carSwitchView.delegate = self;
            
        }
        
        if (_carSwitchView.isShow) {
            [_carSwitchView hide];
        } else {
            [_carSwitchView setSRCArray:@[@"1huhuhhhui", @"2gyugkug", @"3", @"4"]];
            [_carSwitchView showWithView:self.view];
        }
    } else {
        NSLog(@"===== 位置切换 =====");
    }
}

#pragma mark - setter & getter
- (SYButton *)navTitleBtn {
    if (!_navTitleBtn) {
        _navTitleBtn = [[SYButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44) image:[UIImage imageNamed:@"list_down"] title:@"沪A992E1"];
        _navTitleBtn.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentRight;
        [_navTitleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_navTitleBtn addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _navTitleBtn.tag = 100;

    }
    return _navTitleBtn;
}

- (SYButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [[SYButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44) image:[UIImage imageNamed:@"list_down"] title:@"上海"];
        _locationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
        _locationBtn.imgTextDistance = 3;
        _locationBtn.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentRight;
        _locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_locationBtn addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _locationBtn.tag = 101;
    }
    
    return _locationBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 49) style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.carGaugeView;
    }
    
    return _tableView;
}

- (SYHomeCarGaugeView *)carGaugeView {
    if (!_carGaugeView) {
        _carGaugeView = [[SYHomeCarGaugeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 240)];
        _carGaugeView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
        WeakSelf;
        _carGaugeView.block = ^(){
            [weakSelf requestCarLastPosition];
        };
    }
    return _carGaugeView;
}



@end
