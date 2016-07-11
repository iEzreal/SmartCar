//
//  SYMineHeaderView.m
//  SmartCar
//
//  Created by liuyiming on 16/7/9.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYMineHeaderView.h"

@interface SYMineHeaderView ()

@property(nonatomic, strong) UIImageView *bottomBGView;
@property(nonatomic, strong) UIImageView *userPhoto;
@property(nonatomic, strong) UILabel *userName;
@property(nonatomic, strong) UILabel *loginTime;

@property(nonatomic, strong) UIView *bottomLine;


@end

@implementation SYMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _bottomBGView = [[UIImageView alloc] init];
    _bottomBGView.image = [UIImage imageNamed:@"mine_header_bg"];
    [self addSubview:_bottomBGView];
    
    _userPhoto = [[UIImageView alloc] init];
    _userPhoto.image = [UIImage imageNamed:@"user_photo"];
    [self addSubview:_userPhoto];
    
    _userName = [[UILabel alloc] init];
    _userName.font = [UIFont systemFontOfSize:20];
    _userName.textColor = [UIColor whiteColor];
    _userName.text = @"张晓";
    [self addSubview:_userName];
    
    _loginTime = [[UILabel alloc] init];
    _loginTime.font = [UIFont systemFontOfSize:15];
    _loginTime.textColor = [UIColor whiteColor];
    _loginTime.text = @"2016.06.07 2:22";
    [self addSubview:_loginTime];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomLine];
    
    [_bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        
    }];
    
    [_userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(_bottomBGView.mas_top);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userPhoto.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
    
    [_loginTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom).offset(12);
        make.centerX.equalTo(self);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    return self;
}

@end
