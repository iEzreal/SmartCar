//
//  SYTravelReplayController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/7.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYTravelReplayController.h"
#import "SYTravelSportNode.h"


@interface SYTravelReplayController () <BMKMapViewDelegate>

@property(nonatomic, strong) BMKMapView *mapView;
@property(nonatomic, strong) BMKPolyline *pathLine;
@property(nonatomic, strong) BMKPointAnnotation *startAnnotation;
@property(nonatomic, strong) BMKPointAnnotation *endAnnotation;
@property(nonatomic, strong) BMKPointAnnotation *carAnnotation;

@property(nonatomic, strong) NSMutableArray *travelPointArray;

@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, assign) NSInteger pointCount;

@end

@implementation SYTravelReplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程回放";
    
    _travelPointArray = [[NSMutableArray alloc] init];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64)];
    _mapView.zoomLevel = 13;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    [self requestCarTripPosition];
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

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 获取行程详细坐标点信息
- (void)requestCarTripPosition {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:_travel.carId forKey:@"carId"];
    [parameters setObject:_travel.tripTime forKey:@"sTime"];
    [parameters setObject:_travel.tripTime_E forKey:@"eTime"];
    
    [SYApiServer POST:METHOD_GET_CAR_TRIP_POSITION parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        [self parseSportNodeWithJsonString:[responseDic objectForKey:@"poInfo"]];
        
        [self startReplay];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)parseSportNodeWithJsonString:(NSString *)jsonString {
    NSDictionary *nodeDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [nodeDic objectForKey:@"TableInfo"];
    for (int i = 0; i < tableArray.count; i++) {
        SYTravelSportNode *travel = [[SYTravelSportNode alloc] initWithDic:tableArray[i]];
        [_travelPointArray addObject:travel];
    }
}


#pragma mark - 轨迹回放操作
- (void)startReplay {
    _pointCount = _travelPointArray.count;
    CLLocationCoordinate2D baiduCoors[_pointCount];
    for (NSInteger i = 0; i < _pointCount; i++) {
        SYTravelSportNode *node = _travelPointArray[i];
        
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([node.lat doubleValue], [node.lon doubleValue]);
        NSDictionary *dic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS);
        CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(dic);
        baiduCoors[i] = baiduCoor;
    }
    
    // 绘制线路
    _pathLine = [BMKPolyline polylineWithCoordinates:baiduCoors count:_pointCount];
    [_mapView addOverlay:_pathLine];
    
    // 起点标注
    _startAnnotation = [[BMKPointAnnotation alloc]init];
    _startAnnotation.coordinate = baiduCoors[0];
    _mapView.centerCoordinate = baiduCoors[0];
    [_mapView addAnnotation:_startAnnotation];
    
    
    // 终点标注
    _endAnnotation = [[BMKPointAnnotation alloc]init];
    _endAnnotation.coordinate = baiduCoors[_pointCount - 1];
    [_mapView addAnnotation:_endAnnotation];
    
    // 车
    _currentIndex = 0;
    
    _carAnnotation = [[BMKPointAnnotation alloc]init];
    _carAnnotation.coordinate = baiduCoors[0];
    [_mapView addAnnotation:_carAnnotation];
    [self running];
}

- (void)running {
    SYTravelSportNode *node = [_travelPointArray objectAtIndex:_currentIndex];
    [UIView animateWithDuration:0.35 animations:^{
        _currentIndex++;
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([node.lat doubleValue], [node.lon doubleValue]);
        NSDictionary *dic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS);
        CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(dic);
        _carAnnotation.coordinate = baiduCoor;
        
    } completion:^(BOOL finished) {
        if (_currentIndex < _pointCount) {
            [self running];
        }
    }];
}

#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 5;
        return polylineView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if (annotation == _startAnnotation) {
        static NSString *identifier = @"StartAnnotation";
        BMKPinAnnotationView *startAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!startAnnotationView) {
            startAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        startAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        startAnnotationView.animatesDrop = NO;
        startAnnotationView.annotation=annotation;
        startAnnotationView.image = [UIImage imageNamed:@"gps_position"];
        return startAnnotationView;
    }
    
//    if (annotation == _carAnnotation) {
//        static NSString *identifier = @"CarAnnotation";
//        BMKPinAnnotationView *carAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//        if (!carAnnotationView) {
//            carAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//        }
//        
//        carAnnotationView.pinColor = BMKPinAnnotationColorPurple;
//        carAnnotationView.animatesDrop = NO;
//        carAnnotationView.annotation=annotation;
//        carAnnotationView.image = [UIImage imageNamed:@"gps_position"];
//        return carAnnotationView;
//    }
    
    if (annotation == _endAnnotation) {
        static NSString *identifier = @"EndAnnotation";
        BMKPinAnnotationView *endAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!endAnnotationView) {
            endAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        endAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        endAnnotationView.animatesDrop = NO;
        endAnnotationView.annotation=annotation;
        endAnnotationView.image = [UIImage imageNamed:@"end"];
        return endAnnotationView;
    }

    return nil;

}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {

}



@end
