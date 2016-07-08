//
//  SYHomeSpeedGaugeView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeSpeedGaugeView.h"

@interface SYHomeSpeedGaugeView ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *pointImgView;
@property(nonatomic, strong) UILabel *label;

@end

@implementation SYHomeSpeedGaugeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.frame = CGRectMake(0, 0, self.width, self.height - 30);
    _imageView.image = [UIImage imageNamed:@"speed"];
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame), self.width, 30);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:20];
    [self addSubview:_label];
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    _label.text = text;
}


@end
