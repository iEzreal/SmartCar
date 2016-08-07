//
//  SYTravelCell.m
//  SmartCar
//
//  Created by liuyiming on 16/7/5.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYTravelCell.h"

@interface SYTravelCell ()

@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *travelLabel;
@property(nonatomic, strong) UIImageView *lineView;

@end

@implementation SYTravelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:15];
    _dateLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_dateLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_timeLabel];
    
    _travelLabel = [[UILabel alloc] init];
    _travelLabel.textAlignment = NSTextAlignmentCenter;
    _travelLabel.font = [UIFont systemFontOfSize:15];
    _travelLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_travelLabel];
    
    _lineView = [[UIImageView alloc] init];
    _lineView.image = [UIImage imageNamed:@"splitter_line"];
    [self.contentView addSubview:_lineView];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.width.equalTo(self.contentView).dividedBy(3);
        make.height.equalTo(@40);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateLabel);
        make.left.equalTo(_dateLabel.mas_right);
        make.width.equalTo(self.contentView).dividedBy(3);
        make.height.equalTo(_dateLabel);
    }];
    
    [_travelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateLabel);
        make.left.equalTo(_timeLabel.mas_right);
        make.width.equalTo(self.contentView).dividedBy(3);
        make.height.equalTo(_dateLabel);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(SCREEN_W);
        make.height.equalTo(@0.5);
    }];
    
    return self;
}

- (void)setTravelInfo:(SYTravel *)travel {
    _dateLabel.text = [SYUtil dateWithSateStr:travel.tripTime Format:@"yyyy.MM.dd"];
    _timeLabel.text = [SYUtil dateWithSateStr:travel.tripTime Format:@"HH:mm"];
    _travelLabel.text = [NSString stringWithFormat:@"%0.1f公里", [travel.OBDTolMileage_E floatValue] / 10];
}

@end
