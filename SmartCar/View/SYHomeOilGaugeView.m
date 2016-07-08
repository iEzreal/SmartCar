//
//  SYHomeOilGaugeView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeOilGaugeView.h"
#import "SYProgressView.h"

@interface SYHomeOilGaugeView ()

@property(nonatomic, strong) SYProgressView *progressView;
@property(nonatomic, strong) UILabel *label;

@end

@implementation SYHomeOilGaugeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    _progressView = [[SYProgressView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    [self addSubview:_progressView];
    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:16];
    _label.textColor = [UIColor whiteColor];
    [self addSubview:_label];

    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.width);
        make.centerX.equalTo(self);
    }];
    
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    [_progressView setProgress:[text floatValue] / 100 animated:YES];
    _label.text = text;
}

@end
