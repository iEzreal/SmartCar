//
//  SYPageTopView.m
//  SmartCar
//
//  Created by liuyiming on 16/7/22.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYPageTopView.h"

@interface SYPageTopView ()

@property(nonatomic, strong) UIImageView *iconIV;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;

@end

@implementation SYPageTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _iconIV = [[UIImageView alloc] init];
    _iconIV.image = [UIImage imageNamed:@"icon_travel"];
    [self addSubview:_iconIV];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_contentLabel];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.centerY.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconIV.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightBtn.mas_left).offset(-15);
        make.centerY.equalTo(self);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.centerY.equalTo(self);
    }];
    
    return self;
}

- (void)rightBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(topViewRightAction)]) {
        [self.delegate topViewRightAction];
    }
}

- (void)setBGColor:(UIColor *)BGColor {
    _BGColor = BGColor;
    self.backgroundColor = BGColor;
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    _iconIV.image = iconImage;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _contentLabel.text = content;
}


@end
