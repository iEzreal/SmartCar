//
//  SYHomeController.m
//  SmartCar
//
//  Created by xxx on 16/6/25.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYHomeController.h"
#import "SYTravelController.h"
#import "SYCurrentLocationController.h"
#import "SYAlarmController.h"
#import "SYLoginController.h"
#import "AppDelegate.h"

#import "SYCarSwitchView.h"

#import "SYHomeGaugeView.h"
#import "SYHomeTravelView.h"
#import "SYHomeAlarmView.h"

#import "SYVehiclePosition.h"
#import "SYTravel.h"



@interface SYHomeController () <SYHomeGaugeViewDelegate, SYHomeTravelViewDelegate,SYHomeAlarmViewDelegate, BMKMapViewDelegate>

@property(nonatomic, strong) SYHomeGaugeView *gaugeView;
@property(nonatomic, strong) SYHomeTravelView *travelView;
@property(nonatomic, strong) BMKMapView *mapView;
@property(nonatomic, strong) SYHomeAlarmView *alarmView;

@property(nonatomic, strong) BMKPointAnnotation *locationAnnotation;

@property(nonatomic, strong) NSMutableArray *travelArray;

@property(nonatomic, strong) SYVehiclePosition *vePosition;
@property(nonatomic, assign) CGFloat mileage;

@end

@implementation SYHomeController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    _travelArray = [[NSMutableArray alloc] init];
    
    [self setupPageSubviews];
    [self requestGaugeInfo];
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

- (void)reloadPageData {
    [self requestGaugeInfo];
    [self requestCarTrip];
    [self requestAlarmInfo];
}

#pragma mark - 数据请求
- (void)requestGaugeInfo {
    dispatch_group_t requestGroup = dispatch_group_create();

    /*************************************************************************/
    /*                            车辆最后位置信                               */
    /*************************************************************************/
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:carId forKey:@"CarId"];
    
    dispatch_group_enter(requestGroup);
    [SYApiServer POST:METHOD_GET_LAST_POSITION parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"GetLastPositionResult"] integerValue] == 1) {
            NSString *positionStr = [responseDic objectForKey:@"PositionInfo"];
            NSDictionary *positionDic = [positionStr objectFromJSONString];
            NSArray *tableArray = [positionDic objectForKey:@"TableInfo"];
            NSDictionary *dic = tableArray[0];
            _vePosition = [[SYVehiclePosition alloc] initWithDic:dic];
        }
        dispatch_group_leave(requestGroup);
        
    } failure:^(NSError *error) {
        dispatch_group_leave(requestGroup);
        
    }];
    
    /*************************************************************************/
    /*                               初始里程                                 */
    /*************************************************************************/
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    [para setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"CarId"];
    
    dispatch_group_enter(requestGroup);
    [SYApiServer POST:METHOD_GET_MILEAGE parameters:para success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic) {
            _mileage = [[responseDic objectForKey:@"GetMileageResult"] floatValue];
        } else {
            _mileage = 0;
        }
        dispatch_group_leave(requestGroup);
        
    } failure:^(NSError *error) {
        _mileage = 0;
        dispatch_group_leave(requestGroup);
    }];
    
    // 更新数据
    dispatch_group_notify(requestGroup, dispatch_get_main_queue(), ^{
        if (_vePosition) {
            [self addMapAnnotation];
//            _gaugeView.refreshTimeText = _vePosition.recvTime;
            _gaugeView.refreshTimeText = [SYUtil currentDate];
            _gaugeView.oilText = _vePosition.OBDGasLevel;
            _gaugeView.speedText = _vePosition.OBDSpeed;
            _gaugeView.stateText = _vePosition.engineOnOff;
            _gaugeView.voltageText = _vePosition.OBDBatt;
            _gaugeView.mileageText = [NSString stringWithFormat:@"%d", (int)_mileage];
            [SYAppManager sharedManager].showVehicleState = _vePosition.engineOnOff;
        }
        [_gaugeView finishRefresh];
    });
}

// 车辆行程信息
- (void)requestCarTrip {
    NSString *termID = [SYAppManager sharedManager].showVehicle.termID;
    NSString *startTime = [NSDate dateAfterDate:[NSDate date] day:-10];
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

// 报警信息
- (void)requestAlarmInfo {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSString *startTime = [NSString stringWithFormat:@"%@ 00:00:00", [NSDate dateAfterDate:[NSDate date] day:-20]];
    NSString *endTime = [NSString stringWithFormat:@"%@ 23:59:59", [NSDate currentDate]];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"CarId"];
    [parameters setObject:startTime forKey:@"StartTime"];
    [parameters setObject:endTime forKey:@"EndTime"];
    [parameters setObject:[NSNumber numberWithInt:0x7FFFFFFF] forKey:@"mask"];
    
    [SYApiServer POST:METHOD_GET_ALARM_INFO parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"GetAlarmInfoResult"] integerValue] > 0) {
            NSString *alarmStr = [responseDic objectForKey:@"AlarmInfo"];
            NSDictionary *alarmDic = [alarmStr objectFromJSONString];
            NSArray *alarmArray = [alarmDic objectForKey:@"TableInfo"];
            [_alarmView setAlarmArray:alarmArray];
        }
    } failure:^(NSError *error) {
    }];
}

// 车辆体检信息
- (void)parseTravelWithJsonString:(NSString *)jsonString {
    NSDictionary *travelDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [travelDic objectForKey:@"TableInfo"];
    for (int i = 0; i < tableArray.count; i++) {
        SYTravel *travel = [[SYTravel alloc] initWithDic:tableArray[i]];
        [_travelArray addObject:travel];
    }
    
    _travelView.travelArray = _travelArray;
}


// 添加地图标注
- (void)addMapAnnotation {
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
        
            // 发通知
            NSNotification * notice = [NSNotification notificationWithName:notification_update_Location object:nil userInfo:@{@"location":city}];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
            [SYAppManager sharedManager].locationStr = city;
            _locationAnnotation.title = [NSString stringWithFormat:@"%@%@%@", city, subLocality, street];
            [_mapView selectAnnotation:_locationAnnotation animated:YES];
        }
    }];
}

#pragma mark - 代理事件
- (void)refreshPositionAction {
    [self requestGaugeInfo];
//    [self requestCarTrip];
//    [self requestAlarmInfo];
}

- (void)moreTraveAction {
    SYTravelController *travelController = [[SYTravelController alloc] init];
    [self.navigationController pushViewController:travelController animated:YES];
}

- (void)moreAlarmAction {
    SYAlarmController *alarmController = [[SYAlarmController alloc] init];
    [self.navigationController pushViewController:alarmController animated:YES];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    SYCurrentLocationController *locationController = [[SYCurrentLocationController alloc] init];
    locationController.lat = _vePosition.lat;
    locationController.lon = _vePosition.lon;
    [self.navigationController pushViewController:locationController animated:YES];

}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = NO;
        newAnnotationView.annotation = annotation;
        newAnnotationView.image = [UIImage imageNamed:@"location_red"];
        return newAnnotationView;
    }
    return nil;
    
}

#pragma mark - 页面UI
- (void)setupPageSubviews {
    _gaugeView = [[SYHomeGaugeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 65 + 130 * SCALE_H)];
    _gaugeView.delegate = self;
    [self.view addSubview:_gaugeView];
    
    _travelView = [[SYHomeTravelView alloc] initWithFrame:CGRectMake(0, _gaugeView.bottom, SCREEN_W, 55* SCALE_H)];
    _travelView.delegate = self;
    [self.view addSubview:_travelView];
    
    _alarmView = [[SYHomeAlarmView alloc] initWithFrame:CGRectMake(0, _travelView.bottom, SCREEN_W, 55* SCALE_H)];
    [_alarmView addTopBorderWithColor:[UIColor colorWithHexString:@"3E4451"] width:0.7];
    [_alarmView addBottomBorderWithColor:[UIColor colorWithHexString:@"3E4451"] width:0.7];
    _alarmView.delegate = self;
    [self.view addSubview:_alarmView ];

    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, _alarmView.bottom, SCREEN_W , SCREEN_H - _gaugeView.height - _travelView.height - _alarmView.height - 64 - 49)];
    _mapView.zoomLevel = 17;
    [self.view addSubview:_mapView];
    
    
    // 去掉体检
//    _physicalView = [[SYHomePhysicalView alloc] initWithFrame:CGRectMake(_alarmView.left, _alarmView.bottom, _alarmView.width, _mapView.height / 2)];
//    _physicalView.delegate = self;
//    [_physicalView addTopBorderWithColor:[UIColor colorWithHexString:@"3E4451"] width:1];
//    [self.view addSubview:_physicalView ];
}

@end
