//
//  SYHomeStateGaugeView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeStateGaugeView.h"

@interface SYHomeStateGaugeView ()

@property(nonatomic, strong) UIImageView *stateImgView;
@property(nonatomic, strong) UILabel *stateLabel;

@end

@implementation SYHomeStateGaugeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    UIView *placeView = [[UIView alloc] init];
    [self addSubview:placeView];
    _stateImgView = [[UIImageView alloc] init];
    _stateImgView.backgroundColor = [UIColor redColor];
    _stateImgView.layer.cornerRadius = 9;
    _stateImgView.layer.masksToBounds = YES;
    [self addSubview:_stateImgView];
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_stateLabel];
    
    [placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [_stateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(placeView);
        make.width.height.equalTo(@18);
    }];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_stateImgView.mas_right).offset(5);
        make.right.centerY.equalTo(placeView);
    }];
    
    
    return self;
}

- (void)setStateColor:(UIColor *)stateColor {
    _stateColor = stateColor;
    _stateImgView.backgroundColor = stateColor;
    _stateLabel.textColor  = stateColor;

}

- (void)setStateText:(NSString *)stateText {
    _stateText = stateText;
    _stateLabel.text = stateText;
}


@end
