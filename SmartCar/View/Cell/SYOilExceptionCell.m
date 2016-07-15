//
//  SYOilExceptionCell.m
//  SmartCar
//
//  Created by Ezreal on 16/7/14.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYOilExceptionCell.h"

@interface SYOilExceptionCell ()

@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *amountLabel;

@end

@implementation SYOilExceptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:16];
    _dateLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_dateLabel];
    
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.font = [UIFont systemFontOfSize:16];
    _amountLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_amountLabel];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(self.contentView).multipliedBy(0.6);
        make.height.equalTo(@40);
    }];
    
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateLabel);
        make.left.equalTo(_dateLabel.mas_right).offset(10);
        make.width.equalTo(self.contentView).multipliedBy(0.4);
        make.height.equalTo(_dateLabel);
    }];
    
    
    return self;
}

- (void)setDate:(NSString *)date {
    _date = date;
    _dateLabel.text = date;
}

- (void)setAmount:(NSString *)amount {
    _amount = amount;
    _amountLabel.text = amount;
}

@end
