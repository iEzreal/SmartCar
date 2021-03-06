//
//  SYCurrentLocationController.m
//  SmartCar
//
//  Created by xxx on 16/7/12.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYCurrentLocationController.h"
#import "SYLocationNavView.h"
#import "SYPickerAlertView.h"
#import "SYGeofence.h"

@interface SYCurrentLocationController () <SYLocationNavViewDelegate, SYPickerAlertViewDelegate, BMKMapViewDelegate>


@property(nonatomic, strong) SYLocationNavView *navView;
@property(nonatomic, strong) BMKMapView *mapView;

@property(nonatomic, strong) NSArray *fenceTypeArray;
@property(nonatomic, strong) SYPickerAlertView *pickerAlertView;

@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UILabel *locationLabel;
@property(nonatomic, strong) UIView *fenceMenuView;
@property(nonatomic, strong) UIButton *fenceSwitchBtn;

@property(nonatomic, strong) UIView *trackMenuView;
@property(nonatomic, strong) UIButton *stopTrackBtn;
@property(nonatomic, strong) UIButton *startTrackBtn;


@property(nonatomic, strong) NSMutableArray *fenceArray;
@property(nonatomic, assign) NSInteger currentFenceIndex;

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) BMKPointAnnotation *locationAnnotation;
@property(nonatomic, strong) BMKPointAnnotation *fenceAnnotation;
@property(nonatomic, strong) BMKCircle *fenceCircle;

@property(nonatomic, strong) BMKPointAnnotation *trackAnnotation;

@end

@implementation SYCurrentLocationController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的位置";
    
    [self setupFenceData];
    
    _navView = [[SYLocationNavView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    _navView.delegate = self;
    [self.view addSubview:_navView];
    
    _mapView = [[BMKMapView alloc]init];
    _mapView.zoomLevel = 17;
    [self.view addSubview:_mapView];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"1C1C1C"];
    [self.view addSubview:_bottomView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
   
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-64-49);
        make.height.equalTo(@45);
    }];
    
    [_bottomView addSubview:self.locationLabel];
    [_bottomView addSubview:self.fenceMenuView];
    [_bottomView addSubview:self.trackMenuView];
    self.fenceMenuView.hidden = YES;
    self.trackMenuView.hidden = YES;
    
    [self getCircleGeoFence];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    [self stopTrack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 私有方法
- (void)setupFenceData {
    _currentFenceIndex = -1;
    
    _fenceTypeArray = @[@"电子围栏1", @"电子围栏2",
                        @"电子围栏3", @"电子围栏4", @"电子围栏5"];
    
    _fenceArray = [[NSMutableArray alloc] initWithCapacity:5];
    SYGeofence *fence1 = [[SYGeofence alloc] init];
    SYGeofence *fence2 = [[SYGeofence alloc] init];
    SYGeofence *fence3 = [[SYGeofence alloc] init];
    SYGeofence *fence4 = [[SYGeofence alloc] init];
    SYGeofence *fence5 = [[SYGeofence alloc] init];
    [_fenceArray addObject:fence1];
    [_fenceArray addObject:fence2];
    [_fenceArray addObject:fence3];
    [_fenceArray addObject:fence4];
    [_fenceArray addObject:fence5];
}

/* *******************************************************************************/
/*                                 获取地理围栏                                    */
/* *******************************************************************************/
- (void)getCircleGeoFence {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:[carId intValue]] forKey:@"CarId"];
    
    [SYApiServer POST:METHOD_GET_CIRCLE_GEO_FENCE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic) {
            NSString *tableStr = [responseDic objectForKey:@"allfenceInfo"];
            NSDictionary *tableDic = [tableStr objectFromJSONString];
            NSArray *array = [tableDic objectForKey:@"TableInfo"];
            NSDictionary *fenceDic = array[0];
            
            [_fenceArray[0] setType:[fenceDic objectForKey:@"Type1"]];
            [_fenceArray[0] setRad:[fenceDic objectForKey:@"Rad1"]];
            [_fenceArray[0] setLat:[fenceDic objectForKey:@"Lat1"]];
            [_fenceArray[0] setLon:[fenceDic objectForKey:@"Lon1"]];
            
            [_fenceArray[1] setType:[fenceDic objectForKey:@"Type2"]];
            [_fenceArray[1] setRad:[fenceDic objectForKey:@"Rad2"]];
            [_fenceArray[1] setLat:[fenceDic objectForKey:@"Lat2"]];
            [_fenceArray[1] setLon:[fenceDic objectForKey:@"Lon2"]];
            
            [_fenceArray[2] setType:[fenceDic objectForKey:@"Type3"]];
            [_fenceArray[2] setRad:[fenceDic objectForKey:@"Rad3"]];
            [_fenceArray[2] setLat:[fenceDic objectForKey:@"Lat3"]];
            [_fenceArray[2] setLon:[fenceDic objectForKey:@"Lon3"]];
            
            [_fenceArray[3] setType:[fenceDic objectForKey:@"Type4"]];
            [_fenceArray[3] setRad:[fenceDic objectForKey:@"Rad4"]];
            [_fenceArray[3] setLat:[fenceDic objectForKey:@"Lat4"]];
            [_fenceArray[3] setLon:[fenceDic objectForKey:@"Lon4"]];
            
            [_fenceArray[4] setType:[fenceDic objectForKey:@"Type5"]];
            [_fenceArray[4] setRad:[fenceDic objectForKey:@"Rad5"]];
            [_fenceArray[4] setLat:[fenceDic objectForKey:@"Lat5"]];
            [_fenceArray[4] setLon:[fenceDic objectForKey:@"Lon5"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

/* *******************************************************************************/
/*                                 添加电子围栏命令                               */
/* *******************************************************************************/
- (void)setElectronicFence:(NSInteger)fencid radius:(NSInteger)radius lat:(NSInteger)lat lon:(NSInteger)lon {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSString *termId = [SYAppManager sharedManager].showVehicle.termID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:[carId integerValue]] forKey:@"uCarId"];
    [parameters setObject:termId forKey:@"szTermId"];
    [parameters setObject:[NSNumber numberWithInteger:fencid] forKey:@"fencid"];
    [parameters setObject:[NSNumber numberWithInteger:1] forKey:@"cmdtype"];
    [parameters setObject:[NSNumber numberWithInteger:radius] forKey:@"radius"];
    [parameters setObject:[NSNumber numberWithInteger:lat] forKey:@"lat"];
    [parameters setObject:[NSNumber numberWithInteger:lon] forKey:@"lon"];
    [parameters setObject:[NSNumber numberWithInteger:5000] forKey:@"nTimeOut"];
    
    [SYUtil showWithStatus:@"正在设置电子围栏..."];
    [SYApiServer OBD_POST:METHOD_SET_ELECTRONIC_FENCE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"SetElectronicFenceResult"] integerValue] == 0) {
            [self setCircleGeoFence:fencid type:1 rad:radius lat:lat lon:lon];
        } else {
            [SYUtil showErrorWithStatus:@"电子围栏设置失败" duration:2];
        }
    } failure:^(NSError *error) {
         [SYUtil showErrorWithStatus:@"电子围栏设置失败" duration:2];
    }];
}

/* *******************************************************************************/
/*                                   删除电子围栏命令                               */
/* *******************************************************************************/
- (void)delElectronicFence:(NSInteger)fencid radius:(NSInteger)radius lat:(NSInteger)lat lon:(NSInteger)lon{
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSString *termId = [SYAppManager sharedManager].showVehicle.termID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:[carId integerValue]] forKey:@"uCarId"];
    [parameters setObject:termId forKey:@"szTermId"];
    [parameters setObject:[NSNumber numberWithInteger:fencid] forKey:@"fencid"];
    [parameters setObject:[NSNumber numberWithInteger:5000] forKey:@"nTimeOut"];
    
    [SYUtil showWithStatus:@"正在设置电子围栏..."];
    [SYApiServer OBD_POST:METHOD_DEL_ELECTRONIC_FENCE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"DelElectronicFenceResult"] integerValue] == 0) {
            [self setCircleGeoFence:fencid type:3 rad:radius lat:lat lon:lon];
        } else {
            [SYUtil showErrorWithStatus:@"电子围栏设置失败" duration:2];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"电子围栏设置失败" duration:2];
    }];

}

/* *******************************************************************************/
/*                               设置电子围栏数据库信息                              */
/* *******************************************************************************/
- (void)setCircleGeoFence:(NSInteger)fenceNo type:(NSInteger)type rad:(NSInteger)rad lat:(NSInteger)lat lon:(NSInteger)lon {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSString *termId = [SYAppManager sharedManager].showVehicle.termID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:[carId integerValue]] forKey:@"CarID"];
    [parameters setObject:termId forKey:@"TermID"];
    [parameters setObject:[NSNumber numberWithInteger:fenceNo] forKey:@"FencNo"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"Type"];
    [parameters setObject:[NSNumber numberWithInteger:rad] forKey:@"Rad"];
    [parameters setObject:[NSNumber numberWithInteger:lat] forKey:@"Lat"];
    [parameters setObject:[NSNumber numberWithInteger:lon] forKey:@"Lon"];
    
    [SYApiServer POST:METHOD_SET_CIRCLE_GEO_FENCE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"SetCircleGeoFenceResult"] integerValue] == 1) {
            [SYUtil showSuccessWithStatus:@"电子围栏设置成功" duration:2];
        } else {
            [SYUtil showErrorWithStatus:@"电子围栏设置失败" duration:2];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"电子围栏设置失败" duration:2];
    }];
}

/* *******************************************************************************/
/*                               下追踪模式OBD命令                                 */
/* *******************************************************************************/
- (void)setTrackJT {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSString *termId = [SYAppManager sharedManager].showVehicle.termID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:[carId integerValue]] forKey:@"uCarId"];
    [parameters setObject:termId forKey:@"szTermId"];
    [parameters setObject:[NSNumber numberWithInteger:5] forKey:@"nInterval"];
    [parameters setObject:[NSNumber numberWithInteger:15 * 24 * 60] forKey:@"nDealy"];
    [parameters setObject:[NSNumber numberWithInteger:5000] forKey:@"nTimeOut"];
    
    [SYUtil showWithStatus:@"正在设置追踪模式"];
    [SYApiServer OBD_POST:METHOD_SET_TRACK_JT parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"DoSetTrackJTResult"] integerValue] == 0) {
            [self startTrack];
            [SYUtil showSuccessWithStatus:@"追踪模式设置成功" duration:1];
        } else {
            [SYUtil showErrorWithStatus:@"设置失败" duration:2];
        }
    } failure:^(NSError *error) {
         [SYUtil showErrorWithStatus:@"设置失败" duration:2];
    }];
}

// 开启定时器，每五秒更新一次位置信息
- (void)startTrack {
    _startTrackBtn.enabled = NO;
    _stopTrackBtn.enabled = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(requestCarLastPosition) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)stopTrack {
    _startTrackBtn.enabled = YES;
    _stopTrackBtn.enabled = NO;
    [_timer invalidate];
}

/* *******************************************************************************/
/*                               获取车辆最后位置信息                               */
/* *******************************************************************************/
- (void)requestCarLastPosition {
    NSString *carId = [SYAppManager sharedManager].showVehicle.carID;
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:carId forKey:@"CarId"];
    
    [SYApiServer POST:METHOD_GET_LAST_POSITION parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"GetLastPositionResult"] integerValue] == 1) {
           
            NSString *positionInfoStr = [responseDic objectForKey:@"PositionInfo"];
            NSDictionary *positionInfoDic = [positionInfoStr objectFromJSONString];
            
            NSArray *tableArray = [positionInfoDic objectForKey:@"TableInfo"];
            NSDictionary *tableDic = tableArray[0];
            
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([[tableDic objectForKey:@"lat"] doubleValue], [[tableDic objectForKey:@"lon"] doubleValue]);
            NSDictionary *baiduDic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
            CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(baiduDic);
            self.trackAnnotation.coordinate = baiduCoor;
            _mapView.centerCoordinate = baiduCoor;
//            [_mapView addAnnotation:self.trackAnnotation];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

/* *******************************************************************************/
/*                            设置用户当前位置Annotation                            */
/* *******************************************************************************/

- (void)addLocationAnnotation {
    CLLocationDegrees lat = [_lat doubleValue];
    CLLocationDegrees lon = [_lon doubleValue];
    
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(lat, lon);
    NSDictionary *dic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(dic);
    
    _mapView.centerCoordinate = baiduCoor;
    self.locationAnnotation.coordinate = baiduCoor;
    [_mapView addAnnotation:self.locationAnnotation];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
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
            
            NSString *address = [NSString stringWithFormat:@"%@%@%@", city, subLocality, street];
            _locationAnnotation.title = address;
            _locationLabel.text = [NSString stringWithFormat:@"当前位置: %@", address];
        }
    }];
}

/* *******************************************************************************/
/*                                   添加地理围栏                                  */
/* *******************************************************************************/
- (void)addGeofenceWithNum:(NSInteger)num {
    CLLocationDegrees lat = [[_fenceArray[num] lat] doubleValue];
    CLLocationDegrees lon = [[_fenceArray[num] lon] doubleValue];
    CLLocationDistance radius = [[_fenceArray[num] rad] doubleValue];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(lat / 1000000, lon / 1000000);
    self.fenceAnnotation.coordinate = coor;
    self.fenceCircle.coordinate = coor;
    self.fenceCircle.radius = radius;
    _mapView.centerCoordinate = coor;
}

#pragma mark - 点击事件处理
/* *******************************************************************************/
/*                                   点击事件处理                                  */
/* *******************************************************************************/
- (void)buttonClickAction:(UIButton *)sender {
    // 删除电子围栏
    if (sender.tag == 201) {
        if (_currentFenceIndex == -1) {
            [SYUtil showHintWithStatus:@"请选择一个电子围栏" duration:1];
            return;
        }
        
        NSInteger lat = [[_fenceArray[_currentFenceIndex] lat] integerValue];
        NSInteger lon = [[_fenceArray[_currentFenceIndex] lon] integerValue];
        NSInteger fenceId = _currentFenceIndex + 1;
        NSInteger radius = self.fenceCircle.radius;
        [self delElectronicFence:fenceId radius:radius lat:lat lon:lon];
    }
    
    // 减少电子围栏半径
    else if (sender.tag == 202) {
        if (_currentFenceIndex == -1) {
            [SYUtil showHintWithStatus:@"请选择一个电子围栏" duration:1];
            return;
        }

        if (self.fenceCircle.radius > 0) {
            self.fenceCircle.radius -= 10;
        }
    }
    
    // 选择电子围栏类型
    else if (sender.tag == 203) {
        if (!_pickerAlertView) {
            _pickerAlertView = [[SYPickerAlertView alloc] initWithTitle:@"电子围栏" dataArray:_fenceTypeArray];
            _pickerAlertView.delegate = self;
        }
        [_pickerAlertView show];
    }
    
    // 增加电子围栏半径
    else if (sender.tag == 204) {
        if (_currentFenceIndex == -1) {
            [SYUtil showHintWithStatus:@"请选择一个电子围栏" duration:1];
            return;
        }
        self.fenceCircle.radius += 10;
        [_fenceArray[_currentFenceIndex] setRad:[NSString stringWithFormat:@"%f", self.fenceCircle.radius]];
    }
    
    // 添加电子围栏
    else if (sender.tag == 205) {
        if (_currentFenceIndex == -1) {
            [SYUtil showHintWithStatus:@"请选择一个电子围栏" duration:1];
            return;
        }

        NSInteger lat = [[_fenceArray[_currentFenceIndex] lat] integerValue];
        NSInteger lon = [[_fenceArray[_currentFenceIndex] lon] integerValue];
        NSInteger fenceId = _currentFenceIndex + 1;
        NSInteger radius = self.fenceCircle.radius;

        [self setElectronicFence:fenceId radius:radius lat:lat lon:lon];
    }
    
    // 停止跟踪
    else if (sender.tag == 301) {
        [self stopTrack];
    }
    
    // 实时跟踪
    else if (sender.tag == 302) {
        if ([[SYAppManager sharedManager].showVehicleState isEqualToString:@"0"]) {
            [SYUtil showHintWithStatus:@"车辆停止状态不允许进行跟踪" duration:3];
        } else {
            [self setTrackJT];
        }
    }
}

#pragma mark - 代理方法
/* *******************************************************************************/
/*                                 电子围栏选择代理                                */
/* *******************************************************************************/
- (void)pickerAlertView:(SYPickerAlertView *)pickerAlertView didSelectAtIndex:(NSInteger)index {
    _currentFenceIndex = index;
    [_fenceSwitchBtn setTitle:_fenceTypeArray[index] forState:UIControlStateNormal];
    SYGeofence *geofence = _fenceArray[index];
    
    // 已添加状态
    if ([geofence.type isEqualToString:@"1"]) {
        [self addGeofenceWithNum:index];
        
    }
    // 删除状态，设置当前位置为围栏位置
    else {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([_lat doubleValue], [_lon doubleValue]);
        NSDictionary *dic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS);
        CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(dic);

        [_fenceArray[index] setLat:[NSString stringWithFormat:@"%ld", (long)(baiduCoor.latitude * 1000000)]];
        [_fenceArray[index] setLon:[NSString stringWithFormat:@"%ld", (long)(baiduCoor.longitude * 1000000)]];
        [_fenceArray[index] setRad:[NSString stringWithFormat:@"%d", 200]];
        NSString *hintStr = [NSString stringWithFormat:@"电子围栏%ld不存在，默认从当前位置开始设置", (long)(index + 1)];
        [SYUtil showHintWithStatus:hintStr duration:1];
        
        [self addGeofenceWithNum:index];
    }
}

/* *******************************************************************************/
/*                           位置、电器围栏、实时追踪 切换代理                        */
/* *******************************************************************************/
- (void)switchWithIndex:(NSInteger )index {
    if (index == 0) {
        self.locationLabel.hidden = NO;
        self.fenceMenuView.hidden = YES;
        self.trackMenuView.hidden = YES;
        
        [_mapView addAnnotation:self.locationAnnotation];
        _mapView.centerCoordinate = self.locationAnnotation.coordinate;
        
        [_mapView removeAnnotation:self.fenceAnnotation];
        [_mapView removeOverlay:self.fenceCircle];
        [_mapView removeAnnotation:self.trackAnnotation];
        
    } else if (index == 1) {
        self.locationLabel.hidden = YES;
        self.fenceMenuView.hidden = NO;
        self.trackMenuView.hidden = YES;
        
        [_mapView removeAnnotation:self.locationAnnotation];
        [_mapView removeAnnotation:self.trackAnnotation];
        
        [_mapView addAnnotation:self.fenceAnnotation];
        [_mapView addOverlay:self.fenceCircle];
        
    } else {
        self.locationLabel.hidden = YES;
        self.fenceMenuView.hidden = YES;
        self.trackMenuView.hidden = NO;
        
        [_mapView removeAnnotation:self.locationAnnotation];
        [_mapView removeAnnotation:self.fenceAnnotation];
        [_mapView removeOverlay:self.fenceCircle];
        
        [_mapView addAnnotation:self.trackAnnotation];

    }
}

/* *******************************************************************************/
/*                                   百度地图代理                                  */
/* *******************************************************************************/
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self addLocationAnnotation];
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.4];
        circleView.strokeColor = [[UIColor cyanColor] colorWithAlphaComponent:0.4];
        circleView.lineWidth = 0;
        
        return circleView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    // 当前位置
    if (annotation == self.locationAnnotation) {
        static NSString *locationStr = @"LocationAnnotation";
        BMKPinAnnotationView *locationAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:locationStr];
        if (!locationAnnotationView) {
            locationAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:locationStr];
        }
        
        locationAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        locationAnnotationView.animatesDrop = NO;
        locationAnnotationView.annotation=annotation;
        locationAnnotationView.image = [UIImage imageNamed:@"location_red"];
        return locationAnnotationView;
    }
    
    if (annotation == self.trackAnnotation) {
        static NSString *trackStr = @"TrackAnnotation";
        BMKPinAnnotationView *trackStrAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:trackStr];
        if (!trackStrAnnotationView) {
            trackStrAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:trackStr];
        }
        
        trackStrAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        trackStrAnnotationView.animatesDrop = NO;
        trackStrAnnotationView.annotation = annotation;
        trackStrAnnotationView.image = [UIImage imageNamed:@"location_red"];
        return trackStrAnnotationView;
    }

    
//    // 围栏中心点
//    if (annotation == _fenceAnnotation) {
//        static NSString *fenceStr = @"FenceAnnotation";
//        BMKPinAnnotationView *fenceAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:fenceStr];
//        if (!fenceAnnotationView) {
//            fenceAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:fenceStr];
//        }
//        
//        fenceAnnotationView.pinColor = BMKPinAnnotationColorPurple;
//        fenceAnnotationView.animatesDrop = NO;
//        fenceAnnotationView.annotation=annotation;
//        fenceAnnotationView.image = [UIImage imageNamed:@"fence_center"];
//        return fenceAnnotationView;
//    }
    
    return nil;
}

#pragma mark - setter getter
- (BMKPointAnnotation *)locationAnnotation {
    if (!_locationAnnotation) {
         _locationAnnotation = [[BMKPointAnnotation alloc]init];
    }
    return _locationAnnotation;
}

- (BMKPointAnnotation *)fenceAnnotation {
    if (!_fenceAnnotation) {
        _fenceAnnotation = [[BMKPointAnnotation alloc]init];
    }
    return _fenceAnnotation;
}


- (BMKPointAnnotation *)trackAnnotation {
    if (!_trackAnnotation) {
        _trackAnnotation = [[BMKPointAnnotation alloc]init];
    }
    return _trackAnnotation;
}


- (BMKCircle *)fenceCircle {
    if (!_fenceCircle) {
        _fenceCircle = [[BMKCircle alloc] init];
    }
    return _fenceCircle;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W, 45)];
        _locationLabel.font = [UIFont systemFontOfSize:16];
        _locationLabel.textColor = [UIColor whiteColor];
        _locationLabel.text = @"当前位置：";
    }
    return _locationLabel;
}

- (UIView *)fenceMenuView {
    if (!_fenceMenuView) {
        _fenceMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 45)];
        
        UIButton *delFenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delFenceBtn.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
        delFenceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [delFenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delFenceBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delFenceBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        delFenceBtn.tag = 201;
        [_fenceMenuView addSubview:delFenceBtn];
        
        UIButton *subRadiusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [subRadiusBtn setBackgroundImage:[UIImage imageNamed:@"fence_sub"] forState:UIControlStateNormal];
        [subRadiusBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        subRadiusBtn.tag = 202;
        [_fenceMenuView addSubview:subRadiusBtn];
        
        _fenceSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fenceSwitchBtn.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
        _fenceSwitchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_fenceSwitchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fenceSwitchBtn setTitle:@"未选择" forState:UIControlStateNormal];
        [_fenceSwitchBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _fenceSwitchBtn.tag = 203;
        [_fenceMenuView addSubview:_fenceSwitchBtn];
        
        
        UIButton *addRadiusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addRadiusBtn setBackgroundImage:[UIImage imageNamed:@"fence_add"] forState:UIControlStateNormal];
        [addRadiusBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        addRadiusBtn.tag = 204;
        [_fenceMenuView addSubview:addRadiusBtn];
        
        UIButton *addFenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addFenceBtn.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
        addFenceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [addFenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addFenceBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addFenceBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        addFenceBtn.tag = 205;
        [_fenceMenuView addSubview:addFenceBtn];

        [delFenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fenceMenuView).offset(5);
            make.centerY.equalTo(_fenceMenuView);
            make.width.equalTo(@60);
            make.height.equalTo(@40);
        }];
        
        [subRadiusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(delFenceBtn.mas_right).offset(5);
            make.centerY.equalTo(_fenceMenuView);
            make.width.equalTo(@40);
        }];

        [_fenceSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(subRadiusBtn.mas_right).offset(5);
            make.right.equalTo(addRadiusBtn.mas_left).offset(-5);
            make.center.equalTo(_fenceMenuView);
            make.height.equalTo(@40);
        }];
        
        [addRadiusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(addFenceBtn.mas_left).offset(-5);
            make.centerY.equalTo(_fenceMenuView);
            make.width.equalTo(@40);
        }];
        
        [addFenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_fenceMenuView).offset(-5);
            make.centerY.equalTo(_fenceMenuView);
            make.width.equalTo(@60);
            make.height.equalTo(@40);
            
        }];
    }

    return _fenceMenuView;
}

- (UIView *)trackMenuView {
    if (!_trackMenuView) {
        _trackMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 45)];
        
        _stopTrackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopTrackBtn.layer.cornerRadius = 15;
        _stopTrackBtn.layer.masksToBounds = YES;
        _stopTrackBtn.enabled = NO;
        [_stopTrackBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"2ADE75"]] forState:UIControlStateNormal];
        [_stopTrackBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"BDC4C8"]] forState:UIControlStateDisabled];
        _stopTrackBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_stopTrackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stopTrackBtn setTitle:@"停止" forState:UIControlStateNormal];
        [_stopTrackBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _stopTrackBtn.tag = 301;
        [_trackMenuView addSubview:_stopTrackBtn];
        
        _startTrackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startTrackBtn.layer.cornerRadius = 15;
        _startTrackBtn.layer.masksToBounds = YES;
        [_startTrackBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"2ADE75"]] forState:UIControlStateNormal];
        [_startTrackBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"BDC4C8"]] forState:UIControlStateDisabled];
        _startTrackBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_startTrackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startTrackBtn setTitle:@"追踪" forState:UIControlStateNormal];
        [_startTrackBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _startTrackBtn.tag = 302;
        [_trackMenuView addSubview:_startTrackBtn];
        
        [_stopTrackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_trackMenuView).offset(20);
            make.right.equalTo(_trackMenuView.mas_centerX).offset(-10);
            make.centerY.equalTo(_trackMenuView);
            make.height.equalTo(@30);
        }];
        
        [_startTrackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_trackMenuView.mas_centerX).offset(10);
            make.right.equalTo(_trackMenuView).offset(-20);
            make.centerY.equalTo(_trackMenuView);
            make.height.equalTo(_stopTrackBtn);
        }];
    }
    return _trackMenuView;
}

@end
