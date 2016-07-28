//
//  SYMainNavView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/28.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYMainNavView.h"

@interface SYMainNavView ()

@property(nonatomic, strong) UIButton *backBtn;

@property(nonatomic, strong) UIView *centerView;
@property(nonatomic, strong) UIButton *centerBtn;
@property(nonatomic, strong) UIImageView *centerIV;

@property(nonatomic, strong) UIView *rightView;
@property(nonatomic, strong) UIButton *rightBtn;
@property(nonatomic, strong) UIImageView *rightIV;

@end

@implementation SYMainNavView


- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    [self setupPageSubviews];
    [self layoutPageSubviews];
    
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    [_centerBtn setTitle:_titleStr forState:UIControlStateNormal];
}

- (void)setLocationStr:(NSString *)locationStr {
    _locationStr = locationStr;
    [_rightBtn setTitle:_locationStr forState:UIControlStateNormal];
}

- (void)navBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mainNavView:didSelectAtIndex:)]) {
        [self.delegate mainNavView:self didSelectAtIndex:sender.tag];
    }
}

- (void)setupPageSubviews {
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor colorWithHexString:@"EDEDED"] forState:UIControlStateHighlighted];
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(navBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.tag = 0;
    [self addSubview:_backBtn];
    
    _centerView = [[UIView alloc] init];
    [self addSubview:_centerView];
    
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _centerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_centerBtn addTarget:self action:@selector(navBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _centerBtn.tag = 1;
    [self addSubview:_centerBtn];
    
    _centerIV = [[UIImageView alloc] init];
    _centerIV.image = [UIImage imageNamed:@"list_down"];
    [self addSubview:_centerIV];
    
    _rightView = [[UIView alloc] init];
    [self addSubview:_rightView];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(navBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.tag = 2;
    [self addSubview:_rightBtn];
    
    _rightIV = [[UIImageView alloc] init];
    _rightIV.image = [UIImage imageNamed:@"list_down"];
    [self addSubview:_rightIV];


}

- (void)layoutPageSubviews {
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self);
    }];
    
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerView);
        make.left.equalTo(_centerView);
    }];
    [_centerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerBtn.mas_right).offset(5);
        make.right.equalTo(_centerView);
        make.centerY.equalTo(_centerView);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_rightIV.mas_left).offset(-5);
    }];
    
    [_rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self);
    }];

}

@end
