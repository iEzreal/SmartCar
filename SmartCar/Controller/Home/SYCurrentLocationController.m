//
//  SYCurrentLocationController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/12.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYCurrentLocationController.h"
#import "SYLocationNavView.h"
#import "SYPickerView.h"
#import "SYGeofence.h"

@interface SYCurrentLocationController () <SYLocationNavViewDelegate, SYPickerViewDelegate, BMKMapViewDelegate>


@property(nonatomic, strong) SYLocationNavView *navView;
@property(nonatomic, strong) BMKMapView *mapView;

@property(nonatomic, strong) NSArray *fenceTypeArray;
@property(nonatomic, strong) SYPickerView *pickerView;

@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UILabel *locationLabel;
@property(nonatomic, strong) UIView *fenceMenuView;
@property(nonatomic, strong) UIButton *fenceSwitchBtn;
@property(nonatomic, strong) UIView *trackMenuView;


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
        make.left.right.bottom.equalTo(self.view);
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

/**
 *  获取地理围栏
 */
- (void)getCircleGeoFence {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:carId forKey:@"CarId"];
    
    [SYApiServer POST:METHOD_GET_CIRCLE_GEO_FENCE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
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
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  设置电子围栏
 *
 *  @param fenceNo
 *  @param type
 *  @param rad
 *  @param lat
 *  @param lon
 */
- (void)setCircleGeoFence:(NSInteger)fenceNo type:(NSInteger)type rad:(NSInteger)rad lat:(NSInteger)lat lon:(NSInteger)lon {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSString *termId = [SYAppManager sharedManager].vehicle.termID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:[carId integerValue]] forKey:@"CarId"];
    [parameters setObject:termId forKey:@"TermID"];
    [parameters setObject:[NSNumber numberWithInteger:fenceNo] forKey:@"FenceNo"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"Type"];
    [parameters setObject:[NSNumber numberWithInteger:rad] forKey:@"Rad"];
    [parameters setObject:[NSNumber numberWithInteger:lat] forKey:@"Lat"];
    [parameters setObject:[NSNumber numberWithInteger:lon] forKey:@"Lon"];
    
    [SYApiServer POST:METHOD_SET_CIRCLE_GEO_FENCE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
       
        
    } failure:^(NSError *error) {
        
    }];
}

/* *******************************************************************************/
/*                                 设置追踪模式                                    */
/* *******************************************************************************/
- (void)setTrackJT {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSString *termId = [SYAppManager sharedManager].vehicle.termID;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:[carId integerValue]] forKey:@"uCarId"];
    [parameters setObject:termId forKey:@"szTermId"];
    [parameters setObject:[NSNumber numberWithInteger:5] forKey:@"nInterval"];
    [parameters setObject:[NSNumber numberWithInteger:15 * 24 * 60] forKey:@"nDealy"];
    [parameters setObject:[NSNumber numberWithInteger:5000] forKey:@"nTimeOut"];
    
    [SVProgressHUD showWithStatus:@"设置中..."];
    [SYApiServer OBD_POST:METHOD_SET_TRACK_JT parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"DoSetTrackJTResult"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [self startTrack];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"设置失败"];
        }
    } failure:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"设置失败"];
    }];
}

- (void)startTrack {
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(requestCarLastPosition) userInfo:nil repeats:YES];
    [_timer fire];
}

// 获取车辆最后位置信息
- (void)requestCarLastPosition {
    NSString *carId = [SYAppManager sharedManager].vehicle.carID;
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:carId forKey:@"CarId"];
    
    [SYApiServer POST:METHOD_GET_LAST_POSITION parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
       
//        NSDictionary *positionDic = [jsonString objectFromJSONString];
//        NSArray *tableArray = [positionDic objectForKey:@"TableInfo"];
//        NSDictionary *dic = tableArray[0];
        
        if (!_trackAnnotation) {
            _trackAnnotation = [[BMKPointAnnotation alloc]init];
            
        }
//        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([_vePosition.lat doubleValue], [_vePosition.lon doubleValue]);
//        NSDictionary *baiduDic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
//        CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(baiduDic);
//        
//        _locationAnnotation.coordinate = baiduCoor;
//        [_mapView addAnnotation:_locationAnnotation];
//        _mapView.centerCoordinate = baiduCoor;

        
    } failure:^(NSError *error) {
        
    }];
}

- (void)stopTrack {
    [_timer invalidate];
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

/**
 *  添加地理围栏
 *
 *  @param num 围栏序号
 */
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
- (void)buttonClickAction:(UIButton *)sender {
    // 删除电子围栏
    if (sender.tag == 201) {
        
        
    }
    
    // 减少电子围栏半径
    else if (sender.tag == 202) {
        if (self.fenceCircle.radius > 0) {
            self.fenceCircle.radius -= 10;
        }
    }
    
    // 选择电子围栏类型
    else if (sender.tag == 203) {
        if (!_pickerView) {
            _pickerView = [[SYPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64)];
            _pickerView.delegate = self;
            _pickerView.dataSourceArray = _fenceTypeArray;
        }
        [_pickerView showWithView:self.view];
    }
    
    // 增加电子围栏半径
    else if (sender.tag == 204) {
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
        
        [self setCircleGeoFence:_currentFenceIndex + 1 type:1 rad:self.fenceCircle.radius lat:lat lon:lon];

    }
    
    // 停止跟踪
    else if (sender.tag == 301) {
        [self stopTrack];
    }
    
    // 实时跟踪
    else if (sender.tag == 302) {
        [self setTrackJT];
    }
}

#pragma mark - 代理方法
/**
 *  电子围栏选择回调
 *
 *  @param pickerView
 *  @param index
 */
- (void)pickerView:(SYPickerView *)pickerView didSelectAtIndex:(NSInteger)index {
    _currentFenceIndex = index;
    [_fenceSwitchBtn setTitle:_fenceTypeArray[index] forState:UIControlStateNormal];
    SYGeofence *geofence = _fenceArray[index];
    
    // 已添加状态
    if ([geofence.type isEqualToString:@"1"]) {
        [self addGeofenceWithNum:index];
        
    }
    // 删除状态，默认显示当前位置
    else {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([_lat doubleValue], [_lon doubleValue]);
        NSDictionary *dic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS);
        CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(dic);

        [_fenceArray[index] setLat:[NSString stringWithFormat:@"%ld", (NSInteger)(baiduCoor.latitude * 1000000)]];
        [_fenceArray[index] setLon:[NSString stringWithFormat:@"%ld", (NSInteger)(baiduCoor.longitude * 1000000)]];
        [_fenceArray[index] setRad:[NSString stringWithFormat:@"%d", 200]];
        NSString *hintStr = [NSString stringWithFormat:@"电子围栏%ld不存在，默认从当前位置开始设置", index + 1];
        [SYUtil showHintWithStatus:hintStr duration:1];
        
        [self addGeofenceWithNum:index];
    }
}


/**
 *  SYLocationNavViewDelegate
 *
 *  @param index <#index description#>
 */
- (void)switchWithIndex:(NSInteger )index {
    if (index == 0) {
        self.locationLabel.hidden = NO;
        self.fenceMenuView.hidden = YES;
        self.trackMenuView.hidden = YES;
        
        [_mapView addAnnotation:self.locationAnnotation];
        _mapView.centerCoordinate = self.locationAnnotation.coordinate;
        
        [_mapView removeAnnotation:self.fenceAnnotation];
        [_mapView removeOverlay:self.fenceCircle];
        
    } else if (index == 1) {
        self.locationLabel.hidden = YES;
        self.fenceMenuView.hidden = NO;
        self.trackMenuView.hidden = YES;
        
        [_mapView removeAnnotation:self.locationAnnotation];
        [_mapView addAnnotation:self.fenceAnnotation];
        [_mapView addOverlay:self.fenceCircle];
        
    } else {
        self.locationLabel.hidden = YES;
        self.fenceMenuView.hidden = YES;
        self.trackMenuView.hidden = NO;
        
    }
}

#pragma mark - BMKMapViewDelegate
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
    if (annotation == _locationAnnotation) {
        static NSString *locationStr = @"LocationAnnotation";
        BMKPinAnnotationView *locationAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:locationStr];
        if (!locationAnnotationView) {
            locationAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:locationStr];
        }
        
        locationAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        locationAnnotationView.animatesDrop = NO;
        locationAnnotationView.annotation=annotation;
        locationAnnotationView.image = [UIImage imageNamed:@"gps_position"];
        return locationAnnotationView;
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



#pragma mark - 页面UI
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
        
        UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        stopBtn.layer.cornerRadius = 15;
        stopBtn.layer.masksToBounds = YES;
        [stopBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"BDC4C8"]] forState:UIControlStateNormal];
        stopBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
        [stopBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        stopBtn.tag = 301;
        [_trackMenuView addSubview:stopBtn];
        
        UIButton *traceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        traceBtn.layer.cornerRadius = 15;
        traceBtn.layer.masksToBounds = YES;
        [traceBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"2ADE75"]] forState:UIControlStateNormal];
               traceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [traceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [traceBtn setTitle:@"追踪" forState:UIControlStateNormal];
        [traceBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        traceBtn.tag = 302;
        [_trackMenuView addSubview:traceBtn];
        
        [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_trackMenuView).offset(20);
            make.right.equalTo(_trackMenuView.mas_centerX).offset(-10);
            make.centerY.equalTo(_trackMenuView);
            make.height.equalTo(@30);
        }];
        
        [traceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_trackMenuView.mas_centerX).offset(10);
            make.right.equalTo(_trackMenuView).offset(-20);
            make.centerY.equalTo(_trackMenuView);
            make.height.equalTo(stopBtn);
        }];
    }
    return _trackMenuView;
}

@end
