//
//  SYAlarmStatCell.m
//  SmartCar
//
//  Created by Ezreal on 16/7/20.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYAlarmStatCell.h"

@interface SYAlarmStatCell ()


@end

@implementation SYAlarmStatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.font = [UIFont systemFontOfSize:16];
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.text = @"类型";
    [self.contentView addSubview:_typeLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont systemFontOfSize:16];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.text = @"次数";
    [self.contentView addSubview:_countLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.font = [UIFont systemFontOfSize:16];
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.text = @"描述";
    [self addSubview:_descLabel];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(self).dividedBy(3);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeLabel.mas_right).offset(5);
        make.width.equalTo(self).dividedBy(6);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_countLabel.mas_right).offset(5);
        make.width.equalTo(self).dividedBy(2);
        make.centerY.equalTo(self.contentView);
    }];

    return self;

}

@end
