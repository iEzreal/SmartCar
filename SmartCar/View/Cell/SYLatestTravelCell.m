//
//  SYLatestTravelCell.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYLatestTravelCell.h"

@interface SYLatestTravelCell ()

@property(nonatomic, strong) UILabel *travelLabel;

@end

@implementation SYLatestTravelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    _travelLabel = [[UILabel alloc] init];
    _travelLabel.textAlignment = NSTextAlignmentCenter;
    _travelLabel.textColor = [UIColor whiteColor];
    _travelLabel.font = [UIFont systemFontOfSize:14];
    _travelLabel.text = @"07月04日 07:09-20.4公里，耗时：0小时52分";
    [self.contentView addSubview:_travelLabel];
    
    [_travelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView);
        
    }];
    
    return self;
}

- (void)setTravelInfo:(SYTravel *)travel {
    NSString *startTime = travel.recvTime;
    NSString *endTime = travel.recvTime_E;
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSDate *sDate = [date dateFromString:startTime];
    NSTimeInterval s = [sDate timeIntervalSince1970];
    
    NSDate *eDate = [date dateFromString:endTime];
    NSTimeInterval e = [eDate timeIntervalSince1970];
    
    NSTimeInterval cha = e - s;
    NSString *timeString = @"";
    NSString *house = @"";
    NSString *min = @"";
    NSString *sec = @"";
    
    sec = [NSString stringWithFormat:@"%d", (int)cha % 60];
    min = [NSString stringWithFormat:@"%d", (int)cha / 60 % 60];
    house = [NSString stringWithFormat:@"%d", (int)cha / 3600];
    timeString=[NSString stringWithFormat:@"%@小时%@分", house, min];
    _travelLabel.text = [NSString stringWithFormat:@"%@--%.1f公里--耗时%@", startTime, [travel.OBDTolMileage_E floatValue] /10, timeString];

}

@end
