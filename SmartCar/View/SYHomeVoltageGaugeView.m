//
//  SYHomeVoltageGaugeView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeVoltageGaugeView.h"

@interface SYHomeVoltageGaugeView ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *label;

@end

@implementation SYHomeVoltageGaugeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"power"];
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:16];
    [self addSubview:_label];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.centerX.equalTo(self);
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
    
    
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    _label.text = text;
}


@end
