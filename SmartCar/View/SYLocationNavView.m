//
//  SYLocationNavView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/12.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYLocationNavView.h"

@interface SYLocationNavView ()

@property(nonatomic, strong) UIButton *locationBtn;
@property(nonatomic, strong) UIButton *fenceBtn;
@property(nonatomic, strong) UIButton *trackBtn;

@end

@implementation SYLocationNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"00A3E4"]] forState:UIControlStateNormal];
    [_locationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateHighlighted];
    [_locationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateSelected];
    [_locationBtn setImage:[UIImage imageNamed:@"position"] forState:UIControlStateNormal];
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_locationBtn setTitle:@"位置" forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    _locationBtn.selected = YES;
    _locationBtn.tag = 0;
    [self addSubview:_locationBtn];
    
    _fenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fenceBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"00A3E4"]] forState:UIControlStateNormal];
    [_fenceBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateHighlighted];
    [_fenceBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateSelected];
    [_fenceBtn setImage:[UIImage imageNamed:@"fence"] forState:UIControlStateNormal];
    _fenceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_fenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fenceBtn setTitle:@"电子围栏" forState:UIControlStateNormal];
    [_fenceBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    _fenceBtn.tag = 1;
    [self addSubview:_fenceBtn];
    
    _trackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_trackBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"00A3E4"]] forState:UIControlStateNormal];
    [_trackBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateHighlighted];
    [_trackBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateSelected];
    [_trackBtn setImage:[UIImage imageNamed:@"track"] forState:UIControlStateNormal];
    _trackBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_trackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_trackBtn setTitle:@"实时追踪" forState:UIControlStateNormal];
    [_trackBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    _trackBtn.tag = 2;
    [self addSubview:_trackBtn];
    
    [_locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.equalTo(self).dividedBy(3);
        make.height.equalTo(@40);
    }];
    
    [_fenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_locationBtn.mas_right);
        make.top.width.height.equalTo(_locationBtn);
    }];
    
    [_trackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fenceBtn.mas_right);
        make.top.width.height.equalTo(_locationBtn);
    }];
    
    return self;
}

- (void)switchClick:(UIButton *)sender {
    if (sender.tag == 0) {
        _locationBtn.selected = YES;
        _fenceBtn.selected = NO;
        _trackBtn.selected = NO;
        
    } else if (sender.tag == 1) {
        _locationBtn.selected = NO;
        _fenceBtn.selected = YES;
        _trackBtn.selected = NO;
        
    } else {
        _locationBtn.selected = NO;
        _fenceBtn.selected = NO;
        _trackBtn.selected = YES;
    
    }
    
    if ([self.delegate respondsToSelector:@selector(switchWithIndex:)]) {
        [self.delegate switchWithIndex:sender.tag];
    }
}

@end
