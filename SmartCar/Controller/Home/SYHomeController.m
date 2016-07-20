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

#import "SYHomeGaugeView.h"
#import "SYHomeTravelView.h"
#import "SYHomeAlarmView.h"
#import "SYHomePhysicalView.h"

#import "SYVehiclePosition.h"
#import "SYTravel.h"

@interface SYHomeController () <SYCarSwitchViewDelegate, SYHomeGaugeViewDelegate, SYHomeTravelViewDelegate,SYHomeAlarmViewDelegate, SYHomePhysicalViewDelegate, BMKMapViewDelegate>

@property(nonatomic, strong) SYButton *navTitleBtn;
@property(nonatomic, strong) SYButton *locationBtn;

@property(nonatomic, strong) SYCarSwitchView *carSwitchView;

@property(nonatomic, strong) SYHomeGaugeView *gaugeView;
@property(nonatomic, strong) SYHomeTravelView *travelView;
@property(nonatomic, strong) BMKMapView *mapView;
@property(nonatomic, strong) SYHomeAlarmView *alarmView;
@property(nonatomic, strong) SYHomePhysicalView *physicalView;


@property(nonatomic, strong) BMKPointAnnotation *locationAnnotation;


@property(nonatomic, strong) SYVehiclePosition *vePosition;
@property(nonatomic, strong) NSMutableArray *travelArray;

@end

@implementation SYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.titleView = self.navTitleBtn;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.locationBtn];
    
    _travelArray = [[NSMutableArray alloc] init];
    
    [self setupPageSubviews];
    [self requestCarLastPosition];
    [self requestCarTrip];
    [self requestAlarmInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
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
        if (responseDic && [[responseDic objectForKey:@"GetLastPositionResult"] integerValue] == 1) {
            [self parseVehickePositionWithJsonString:[responseDic objectForKey:@"PositionInfo"]];
        }
        
        [_gaugeView endRefresh];
    } failure:^(NSError *error) {
        [_gaugeView endRefresh];
    }];
}
/**
 *  查询车辆行程信息
 */
- (void)requestCarTrip {
    NSString *termID = [SYAppManager sharedManager].vehicle.termID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] day:-7];
    NSString *endTime = [NSDate currentDate];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:termID forKey:@"TermId"];
    [parameters setObject:startTime forKey:@"sTime"];
    [parameters setObject:endTime forKey:@"eTime"];
    
    [SYApiServer POST:METHOD_GET_CAR_TRIP parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if ([[responseDic objectForKey:@"GetCarTripResult"] integerValue] > 0) {
             [self parseTravelWithJsonString:[responseDic objectForKey:@"tripInfo"]];
        }
    } failure:^(NSError *error) {
       
    }];
}

/**
 *  请求警告信息
 */
- (void)requestAlarmInfo {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] day:-7];
    NSString *endTime = [NSDate currentDate];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    [parameters setObject:[NSNumber numberWithInt:0x7FFFFFFF] forKey:@"mask"];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [SYApiServer POST:METHOD_GET_ALARM_INFO parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if ([[responseDic objectForKey:@"GetAlarmInfoResult"] integerValue] > 0) {
            NSString *alarmStr = [responseDic objectForKey:@"AlarmInfo"];
            NSDictionary *alarmDic = [alarmStr objectFromJSONString];
            NSArray *alarmArray = [alarmDic objectForKey:@"TableInfo"];
            [_alarmView setAlarmArray:alarmArray];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}




- (void)parseTravelWithJsonString:(NSString *)jsonString {
    NSDictionary *travelDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [travelDic objectForKey:@"TableInfo"];
    for (int i = 0; i < tableArray.count; i++) {
        SYTravel *travel = [[SYTravel alloc] initWithDic:tableArray[i]];
        [_travelArray addObject:travel];
    }
    
    _travelView.travelArray = _travelArray;
}


- (void)parseVehickePositionWithJsonString:(NSString *)jsonString {
    NSDictionary *positionDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [positionDic objectForKey:@"TableInfo"];
    NSDictionary *dic = tableArray[0];
    
    _vePosition = [[SYVehiclePosition alloc] initWithDic:dic];
    _gaugeView.refreshTimeText = _vePosition.recvTime;
    _gaugeView.oilText = _vePosition.OBDGasLevel;
    _gaugeView.speedText = _vePosition.OBDSpeed;
    _gaugeView.stateText = _vePosition.engineOnOff;
    _gaugeView.voltageText = _vePosition.OBDBatt;
    _gaugeView.mileageText = _vePosition.mileage;
    
    if (!_locationAnnotation) {
        _locationAnnotation = [[BMKPointAnnotation alloc]init];
        
    }
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([_vePosition.lat doubleValue], [_vePosition.lon doubleValue]);
    NSDictionary *baiduDic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(baiduDic);

    _locationAnnotation.coordinate = baiduCoor;
    [_mapView addAnnotation:_locationAnnotation];
     _mapView.centerCoordinate = baiduCoor;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[_vePosition.lat doubleValue] longitude:[_vePosition.lon doubleValue]];
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error && [placemarks count] > 0) {
            NSDictionary *dict = [[placemarks objectAtIndex:0] addressDictionary];
            NSString *city = [dict objectForKey:@"City"];;
            NSString *subLocality = [dict objectForKey:@"SubLocality"];
            NSString *street = [dict objectForKey:@"Street"];
            
            if (!city) {
                city = @"";
            }
            
            if (!subLocality) {
                subLocality = @"";
            }
            
            if (!street) {
                street = @"";
            }
            _locationAnnotation.title = [NSString stringWithFormat:@"%@%@%@", city, subLocality, street];
            [_mapView selectAnnotation:_locationAnnotation animated:YES];
        }
    }];
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
            [_carSwitchView setSRCArray:@[[SYAppManager sharedManager].vehicle.carNum]];
            [_carSwitchView showWithView:self.view];
        }
    } else {
        NSLog(@"===== 位置切换 =====");
    }
}



#pragma mark - 切换车车辆
- (void)carSwitchView:(SYCarSwitchView *)carSwitchView didSelectRowAtIndex:(NSInteger)index {
    
}

- (void)refreshPositionAction {
    [self requestCarLastPosition];
}

- (void)moreTraveAction {
    SYTravelController *travelController = [[SYTravelController alloc] init];
    travelController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:travelController animated:YES];
}

- (void)moreAlarmAction {
    SYAlarmController *alarmController = [[SYAlarmController alloc] init];
    alarmController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:alarmController animated:YES];
}

- (void)morePhysicalAction {
    SYPhysicalController *physicalController = [[SYPhysicalController alloc] init];
    physicalController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:physicalController animated:YES];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    SYCurrentLocationController *locationController = [[SYCurrentLocationController alloc] init];
    locationController.lat = _vePosition.lat;
    locationController.lon = _vePosition.lon;
    locationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:locationController animated:YES];

}

//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
//        newAnnotationView.annotation = annotation;
//        newAnnotationView.image = [UIImage imageNamed:@"gps_position"];
//        return newAnnotationView;
//    }
//    return nil;
//    
//}




#pragma mark - 页面UI
- (void)setupPageSubviews {
    _gaugeView = [[SYHomeGaugeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 190)];
    _gaugeView.delegate = self;
    [self.view addSubview:_gaugeView];
    
    _travelView = [[SYHomeTravelView alloc] initWithFrame:CGRectMake(0, _gaugeView.bottom, SCREEN_W, 140)];
    [_travelView addBottomBorderWithColor:[UIColor colorWithHexString:@"3E4451"] width:1];
    _travelView.delegate = self;
    [self.view addSubview:_travelView];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, _travelView.bottom, SCREEN_W / 2 + 30, SCREEN_H - 190 - 140 - 64 - 49)];
    _mapView.zoomLevel = 16;
    [_mapView addRightBorderWithColor:[UIColor colorWithHexString:@"3E4451"] width:1];
    [self.view addSubview:_mapView];
    
    _alarmView = [[SYHomeAlarmView alloc] initWithFrame:CGRectMake(SCREEN_W / 2 + 30, _mapView.top, SCREEN_W / 2 - 30, _mapView.height / 2)];
    _alarmView.delegate = self;
    [self.view addSubview:_alarmView ];
    
    _physicalView = [[SYHomePhysicalView alloc] initWithFrame:CGRectMake(_alarmView.left, _alarmView.bottom, _alarmView.width, _mapView.height / 2)];
    _physicalView.delegate = self;
    [_physicalView addTopBorderWithColor:[UIColor colorWithHexString:@"3E4451"] width:1];
    [self.view addSubview:_physicalView ];
}



#pragma mark - setter & getter
- (SYButton *)navTitleBtn {
    if (!_navTitleBtn) {
        _navTitleBtn = [[SYButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44) image:[UIImage imageNamed:@"list_down"] title:[SYAppManager sharedManager].vehicle.carNum];
        _navTitleBtn.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentRight;
        _navTitleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
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


@end
