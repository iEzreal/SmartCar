//
//  SYHomeMenuCell.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeMenuCell.h"
#import "SYHomeAlarmView.h"
#import "SYHomeCarPhysicalView.h"

@interface SYHomeMenuCell () <BMKMapViewDelegate>

@property(nonatomic, strong) UIImageView *lineView1;
@property(nonatomic, strong) UIImageView *lineView2;
@property(nonatomic, strong) BMKMapView *mapView;

@property(nonatomic, strong) SYHomeAlarmView *alarmView;
@property(nonatomic, strong) SYHomeCarPhysicalView *carPhysicalView;

@end

@implementation SYHomeMenuCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    _lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 1)];
    _lineView1.image = [UIImage imageNamed:@"splitter_line"];
    [self.contentView addSubview:_lineView1];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_W / 2, SCREEN_W / 2)];
    _mapView.zoomLevel = 13;
    _mapView.delegate = self;
    [_mapView addGestureRecognizer:tapGesture];
    [self.contentView addSubview:_mapView];
    
    _alarmView = [[SYHomeAlarmView alloc] initWithFrame:CGRectMake(SCREEN_W / 2, 1, SCREEN_W / 2, SCREEN_W / 4)];
    [self.contentView addSubview:_alarmView];
    
    _lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W / 2, _alarmView.bottom, SCREEN_W, 1)];
    _lineView2.image = [UIImage imageNamed:@"splitter_line"];
    [self.contentView addSubview:_lineView2];
    
    _carPhysicalView = [[SYHomeCarPhysicalView alloc] initWithFrame:CGRectMake(SCREEN_W / 2, _lineView2.bottom, SCREEN_W / 2, SCREEN_W / 4)];
    [self.contentView addSubview:_carPhysicalView];
    
    WeakSelf;
    _alarmView.block = ^(){
        if (weakSelf.block) {
            weakSelf.block(1);
        }
    };
    _carPhysicalView.block = ^(){
        if (weakSelf.block) {
            weakSelf.block(2);
        }
    };
    
    return self;
}

- (void)tapGesture:(UITapGestureRecognizer *)sender {
    if (self.block) {
        self.block(0);
    }
}

#pragma mark - 跟新地图位置
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.annotation = annotation;
        newAnnotationView.image = [UIImage imageNamed:@"gps_position"];
        return newAnnotationView;
    }
    return nil;
}

// 反地理编码
- (void)setMapPointWithLat:(CGFloat)lat lon:(CGFloat)lon {
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lon;
    annotation.coordinate = coor;
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
            annotation.title = [NSString stringWithFormat:@"%@%@%@", city, subLocality, street];
            [_mapView selectAnnotation:annotation animated:YES];
        }
    }];
    
    _mapView.centerCoordinate = coor;
    [_mapView addAnnotation:annotation];
}



@end
