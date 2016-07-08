//
//  SYTravelDetailsController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/7.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYTravelDetailsController.h"
#import "SYTravelReplayController.h"
#import "SYTravelDetailsCell.h"

@interface SYTravelDetailsController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSString *startPoint;
@property(nonatomic, strong) NSString *endPoint;

@end

@implementation SYTravelDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细行程";
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitle:@"查看行程" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(checkTravelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self reverseGeocode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setTravel:(SYTravel *)travel {
    _travel = travel;
}

// 反地理编码
- (void)reverseGeocode {
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:[_travel.lat doubleValue] longitude:[_travel.lon doubleValue]];
    CLGeocoder *startGeocoder = [[CLGeocoder alloc] init];
    [startGeocoder reverseGeocodeLocation:startLocation completionHandler:^(NSArray *placemarks, NSError *error) {
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
            _startPoint = [NSString stringWithFormat:@"%@%@%@", city, subLocality, street];
            [_tableView reloadData];
        }
    }];
    
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:[_travel.lat_E doubleValue] longitude:[_travel.lon_E doubleValue]];
    CLGeocoder *endGeocoder = [[CLGeocoder alloc] init];
    [endGeocoder reverseGeocodeLocation:endLocation completionHandler:^(NSArray *placemarks, NSError *error) {
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
            _endPoint = [NSString stringWithFormat:@"%@%@%@", city, subLocality, street];
            [_tableView reloadData];
        }
    }];
}

- (void)checkTravelAction:(UIButton *)sender {
    SYTravelReplayController *replayController = [[SYTravelReplayController alloc] init];
    replayController.travel = _travel;
    [self.navigationController pushViewController:replayController animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SYTravelDetailsCellCell";
    SYTravelDetailsCell *travelCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!travelCell) {
        travelCell = [[SYTravelDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        travelCell.selectionStyle = UITableViewCellSelectionStyleNone;
        travelCell.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    }
    if (indexPath.row == 0) {
        travelCell.title = @"总行程";
        CGFloat mileage = ([_travel.OBDTolMileage_E floatValue] - [_travel.OBDTolMileage floatValue]) / 10;
        travelCell.content = [NSString stringWithFormat:@"%.1f公里", mileage];
        
    } else if (indexPath.row == 1) {
        travelCell.title = @"出发日期/时间";
        travelCell.content = _travel.tripTime;
        
    } else if (indexPath.row == 2) {
        travelCell.title = @"出发地点";
        travelCell.content = _startPoint;
    } else if (indexPath.row == 3) {
        travelCell.title = @"到达日期/时间";
        travelCell.content = _travel.tripTime_E;
        
    } else if (indexPath.row == 4) {
        travelCell.title = @"到达地点";
        travelCell.content = _endPoint;
        
    } else if (indexPath.row == 5) {
        travelCell.title = @"总时间";
        travelCell.content = [SYUtil intervalFromTime:_travel.tripTime toTime:_travel.tripTime_E];
    }
    
    return travelCell;
}

@end
