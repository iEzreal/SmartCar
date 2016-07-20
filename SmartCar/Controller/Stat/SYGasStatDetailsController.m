//
//  SYGasStatDetailsController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/13.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYGasStatDetailsController.h"

@interface SYGasStatDetailsController () <BMKMapViewDelegate>

@property(nonatomic, strong) UIView *gasStationView;
@property(nonatomic, strong) UILabel *gasStationHintLabel;
@property(nonatomic, strong) UILabel *gasStationLabel;

@property(nonatomic, strong) UIView *timeView;
@property(nonatomic, strong) UILabel *timeHintLabel;
@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) UIView *oliAmountView;
@property(nonatomic, strong) UILabel *oliAmountHintLabel;
@property(nonatomic, strong) UILabel *oliAmountLabel;

@property(nonatomic, strong) BMKMapView *mapView;

@end

@implementation SYGasStatDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加油详细信息";
    
    [self setupPageSubviews];
    [self layoutPageSubviews];

    _timeLabel.text = [_gasDic objectForKey:@"gpstime"];
    
    NSString *OBDGasLevel = [_gasDic objectForKey:@"OBDGasLevel"];
    NSString *OBDHistoryGasLevel = [_gasDic objectForKey:@"OBDHistoryGasLevel"];
    CGFloat amount = ([OBDGasLevel floatValue] - [OBDHistoryGasLevel floatValue]) * [[SYAppManager sharedManager].vehicle.tankCapacity floatValue] / 100;
    _oliAmountLabel.text = [NSString stringWithFormat:@"%.2f", amount];

    
    double lat = [[_gasDic objectForKey:@"lat"] doubleValue];
    double lon = [[_gasDic objectForKey:@"lon"] doubleValue];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(lat, lon);
    NSDictionary *baiduDic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(baiduDic);
   
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = baiduCoor;
    _mapView.centerCoordinate = baiduCoor;
    [_mapView addAnnotation:annotation];
    
    
    [self reverseGeocodeWithLat:lat lon:lon];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

#pragma mark - 反地理编码
- (void)reverseGeocodeWithLat:(double)lat lon:(double)lon {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
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
            
            _gasStationLabel.text = [NSString stringWithFormat:@"%@%@%@", city, subLocality, street];
        }
    }];
}

#pragma mark - 页面布局
- (void)setupPageSubviews {
    
    // 加油站
    _gasStationView = [[UIView alloc] init];
    [self.view addSubview:_gasStationView];
    
    _gasStationHintLabel = [[UILabel alloc] init];
    _gasStationHintLabel.font = [UIFont systemFontOfSize:16];
    _gasStationHintLabel.textColor = [UIColor whiteColor];
    _gasStationHintLabel.text = @"加油站";
    [_gasStationView addSubview:_gasStationHintLabel];
    
    _gasStationLabel = [[UILabel alloc] init];
    _gasStationLabel.font = [UIFont systemFontOfSize:16];
    _gasStationLabel.textColor = [UIColor whiteColor];
    [_gasStationView addSubview:_gasStationLabel];
    
    // 加油时间
    _timeView = [[UIView alloc] init];
    [self.view addSubview:_timeView];
    
    _timeHintLabel = [[UILabel alloc] init];
    _timeHintLabel.font = [UIFont systemFontOfSize:16];
    _timeHintLabel.textColor = [UIColor whiteColor];
    _timeHintLabel.text = @"时间";
    [_timeView addSubview:_timeHintLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textColor = [UIColor whiteColor];
    [_timeView addSubview:_timeLabel];
    
    // 加油量
    _oliAmountView = [[UIView alloc] init];
    [self.view addSubview:_oliAmountView];
    
    _oliAmountHintLabel = [[UILabel alloc] init];
    _oliAmountHintLabel.font = [UIFont systemFontOfSize:16];
    _oliAmountHintLabel.textColor = [UIColor whiteColor];
    _oliAmountHintLabel.text = @"油量(L)";
    [_oliAmountView addSubview:_oliAmountHintLabel];
    
    _oliAmountLabel = [[UILabel alloc] init];
    _oliAmountLabel.font = [UIFont systemFontOfSize:16];
    _oliAmountLabel.textColor = [UIColor whiteColor];
    [_oliAmountView addSubview:_oliAmountLabel];
    
    // 地图
    _mapView = [[BMKMapView alloc]init];
    _mapView.delegate = self;
    _mapView.zoomLevel = 19;
    [self.view addSubview:_mapView];

}

- (void)layoutPageSubviews {
    
    // 加油站
    [_gasStationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [_gasStationHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_gasStationView).offset(10);
        make.centerY.equalTo(_gasStationView);
    }];
    
    [_gasStationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_gasStationView).offset(-10);
        make.centerY.equalTo(_gasStationView);
    }];
    
    // 加油时间
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_gasStationView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(_gasStationView);
    }];
    
    [_timeHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeView).offset(10);
        make.centerY.equalTo(_timeView);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_timeView).offset(-10);
        make.centerY.equalTo(_timeView);
    }];

    // 加油量
    [_oliAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(_gasStationView);
    }];
    
    [_oliAmountHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_oliAmountView).offset(10);
        make.centerY.equalTo(_oliAmountView);
    }];
    
    [_oliAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_oliAmountView).offset(-10);
        make.centerY.equalTo(_oliAmountView);
    }];
    
    [_gasStationView addBottomBorderWithColor:[UIColor whiteColor] width:1];
    [_timeView addBottomBorderWithColor:[UIColor whiteColor] width:1];
    [_oliAmountView addBottomBorderWithColor:[UIColor whiteColor] width:1];
    
    // 地图
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oliAmountView.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-5);
        make.bottom.equalTo(self.view).offset(-5);
    }];
}

@end
