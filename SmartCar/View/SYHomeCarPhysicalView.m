//
//  SYHomeCarPhysicalView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeCarPhysicalView.h"

@interface SYHomeCarPhysicalView ()

@property(nonatomic, strong) UIImageView *iconImgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *moreButton;
@property(nonatomic, strong) UILabel *alarmLabel;

@end

@implementation SYHomeCarPhysicalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.image = [UIImage imageNamed:@"icon_physical"];
    [self addSubview:_iconImgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"车辆体检";
    [self addSubview:_titleLabel];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.backgroundColor = [UIColor colorWithHexString:@"22C064"];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(checkPhysicalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreButton];
    
    _alarmLabel = [[UILabel alloc] init];
    _alarmLabel.numberOfLines = 0;
    _alarmLabel.textColor = [UIColor whiteColor];
    _alarmLabel.font = [UIFont systemFontOfSize:14];
    _alarmLabel.text = @"aoiffioshfsoikkkkkkkkdfhsodifhodf";
    [self addSubview:_alarmLabel];
    
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(5);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImgView.mas_right).offset(5);
        make.centerY.equalTo(_iconImgView);
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(_iconImgView);
        make.width.equalTo(@65);
    }];
    
    [_alarmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moreButton.mas_bottom).offset(5);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
    }];

    return self;
}

- (void)checkPhysicalAction:(UIButton *)sender {
    if (_block) {
        _block();
    }
}

@end
