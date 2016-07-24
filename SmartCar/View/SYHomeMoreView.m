//
//  SYLatestTravelHeaderView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeMoreView.h"

@interface SYHomeMoreView ()

@property(nonatomic, strong) UIImageView *iconImgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *moreButton;

@end

@implementation SYHomeMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.image = [UIImage imageNamed:@"icon_travel"];
    [self addSubview:_iconImgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"近期里程";
    [self addSubview:_titleLabel];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [self addSubview:_moreButton];
    
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImgView.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(self);
    }];
    
    
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _iconImgView.image = _image;
}

- (void)setMoreBGColor:(UIColor *)moreBGColor {
    _moreBGColor = moreBGColor;
    _moreButton.backgroundColor = _moreBGColor;
}

- (void)moreTravelAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(moreAction)]) {
        [self.delegate moreAction];
    }
}


@end
