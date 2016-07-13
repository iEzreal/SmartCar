//
//  SYCurrentLocationController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/12.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYCurrentLocationController.h"
#import "SYLocationNavView.h"

@interface SYCurrentLocationController () <SYLocationNavViewDelegate, BMKMapViewDelegate>


@property(nonatomic, strong) SYLocationNavView *navView;
@property(nonatomic, strong) BMKMapView *mapView;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UILabel *locationLabel;

@end

@implementation SYCurrentLocationController

- (void)viewDidLoad {
    [super viewDidLoad];

    _navView = [[SYLocationNavView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    _navView.delegate = self;
    [self.view addSubview:_navView];
    
    _mapView = [[BMKMapView alloc]init];
    _mapView.zoomLevel = 13;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake([_lat doubleValue], [_lon doubleValue]);
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(40, 0, 40, 0));
    }];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bottom - 40, SCREEN_W, 40)];
    _bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bottomView];
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W - 20, 40)];
    _locationLabel.textColor = [UIColor whiteColor];
    _locationLabel.text = _curLocation;
    [_bottomView addSubview:_locationLabel];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addLocationAnnotation];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)addLocationAnnotation {
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake([_lat doubleValue], [_lon doubleValue]);
    [_mapView addAnnotation:annotation];
}

- (void)switchWithIndex:(NSInteger )index {
    if (index == 0) {
        [self addLocationAnnotation];
        
    } else if (index == 1) {
        
    
    } else {
    
    }
    

}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.annotation=annotation;
        newAnnotationView.image = [UIImage imageNamed:@"gps_position"];   //把大头针换成别的图片
       
        newAnnotationView.image = [UIImage imageNamed:@"gps_position"];   //把大头针换成别的图片
       
        return newAnnotationView;
    }
    
    return nil;

}


@end
