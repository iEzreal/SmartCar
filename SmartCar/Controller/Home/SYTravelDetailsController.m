//
//  SYTravelDetailsController.m
//  SmartCar
//
//  Created by liuyiming on 16/7/7.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYTravelDetailsController.h"
#import "SYTravelReplayController.h"
#import "SYTravelDetailsCell.h"
#import "SYPageTopView.h"
#import "SYPickerAlertView.h"

@interface SYTravelDetailsController () <SYPageTopViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) SYPageTopView *topView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSString *startPoint;
@property(nonatomic, strong) NSString *endPoint;

@end

@implementation SYTravelDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topView = [[SYPageTopView alloc] init];
    _topView.backgroundColor = [UIColor colorWithHexString:PAGE_TOP_COLOR];
    _topView.iconImage = [UIImage imageNamed:@"icon_travel_white"];
    _topView.title= @"近期行程";
    _topView.rightBtn.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _topView.rightBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    _topView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_topView.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_topView.rightBtn setTitle:@"查看行程" forState:UIControlStateNormal];
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-64-49);
    }];
    
    [self reverseGeocode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

#pragma mark - 代理方法
- (void)topViewRightAction {
    SYTravelReplayController *replayController = [[SYTravelReplayController alloc] init];
    replayController.travel = _travel;
    [self.navigationController pushViewController:replayController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
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
