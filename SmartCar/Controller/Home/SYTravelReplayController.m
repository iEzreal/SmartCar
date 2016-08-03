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

@property(nonatomic, assign) NSInteger pointIndex;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation SYTravelReplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程回放";
    
    _travelPointArray = [[NSMutableArray alloc] init];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 49)];
    _mapView.zoomLevel = 15;
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
     _timer =[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(travelReplay) userInfo:nil repeats:YES];
}

- (void)travelReplay {
    if (_pointIndex < _travelPointArray.count) {
        SYTravelSportNode *node = _travelPointArray[_pointIndex];
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([node.lat doubleValue], [node.lon doubleValue]);
        NSDictionary *dic = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS);
        CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(dic);
        
        if (_pointIndex == 0) {
            _startAnnotation = [[BMKPointAnnotation alloc]init];
            _startAnnotation.coordinate = baiduCoor;
            _mapView.centerCoordinate = baiduCoor;
            [_mapView addAnnotation:_startAnnotation];
            
        } else if (_pointIndex == _travelPointArray.count - 1) {
            _endAnnotation = [[BMKPointAnnotation alloc]init];
            _endAnnotation.coordinate = baiduCoor;
            [_mapView addAnnotation:_endAnnotation];
            
        } else {
            BMKPointAnnotation *point = [[BMKPointAnnotation alloc]init];
            point.coordinate = baiduCoor;
            _mapView.centerCoordinate = baiduCoor;
            [_mapView addAnnotation:point];
            
            SYTravelSportNode *nextNode = _travelPointArray[_pointIndex + 1];
            CLLocationCoordinate2D nextCoor = CLLocationCoordinate2DMake([nextNode.lat doubleValue], [nextNode.lon doubleValue]);
            NSDictionary *nextDic = BMKConvertBaiduCoorFrom(nextCoor, BMK_COORDTYPE_GPS);
            CLLocationCoordinate2D nextBaiduCoor = BMKCoorDictionaryDecode(nextDic);
            
            // 绘制线路
            CLLocationCoordinate2D baiduCoors[2];
            baiduCoors[0] = baiduCoor;
            baiduCoors[1] = nextBaiduCoor;
            _pathLine = [BMKPolyline polylineWithCoordinates:baiduCoors count:2];
            [_mapView addOverlay:_pathLine];
        }
        _pointIndex++;
        
    } else {
        [_timer invalidate];
    }
}

#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0);
    
}

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
        
    } else if (annotation == _endAnnotation) {
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
        
    } else {
        static NSString *identifier = @"MiddleAnnotationView";
        BMKPinAnnotationView *middleAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!middleAnnotationView) {
            middleAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        middleAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        middleAnnotationView.animatesDrop = NO;
        middleAnnotationView.annotation = annotation;
        middleAnnotationView.image = [UIImage imageNamed:@"pin_red"];
        
        middleAnnotationView.centerOffset = CGPointMake(0, -(middleAnnotationView.frame.size.height * 0.5));
        return middleAnnotationView;
    }

    return nil;

}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {

}



@end
