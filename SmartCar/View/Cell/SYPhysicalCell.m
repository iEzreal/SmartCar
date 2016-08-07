//
//  SYPhysicalCell.m
//  SmartCar
//
//  Created by liuyiming on 16/7/12.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYPhysicalCell.h"

@interface SYPhysicalCell ()

@property(nonatomic, strong) UILabel *faultCodeLabel;
@property(nonatomic, strong) UILabel *faultDescLabel;

@end

@implementation SYPhysicalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    _faultCodeLabel = [[UILabel alloc] init];
    _faultCodeLabel.textAlignment = NSTextAlignmentCenter;
    _faultCodeLabel.font = [UIFont systemFontOfSize:16];
    _faultCodeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_faultCodeLabel];
    
    _faultDescLabel = [[UILabel alloc] init];
    _faultDescLabel.font = [UIFont systemFontOfSize:16];
    _faultDescLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_faultDescLabel];
    
    [_faultCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@100);
    }];
    
    [_faultDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_faultCodeLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    
    return self;
}

- (void)setFaultCode:(NSString *)faultCode {
    _faultCode = faultCode;
    _faultCodeLabel.text = faultCode;
}

- (void)setFaultDesc:(NSString *)faultDesc {
    _faultDesc = faultDesc;
    _faultDescLabel.text = faultDesc;
}

@end
