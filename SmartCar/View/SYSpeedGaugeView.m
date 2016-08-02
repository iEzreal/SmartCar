//
//  SYSpeedGaugeView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/29.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYSpeedGaugeView.h"

@interface SYSpeedGaugeView ()

@property(nonatomic, strong) UIImageView *bg;
@property(nonatomic, strong) UIView *dot;
@property(nonatomic, strong) UIView *pointer;

@property(nonatomic, assign) CGFloat minNum;
@property(nonatomic, assign) CGFloat maxNum;

@property(nonatomic, assign) CGFloat minAngle;
@property(nonatomic, assign) CGFloat maxAngle;

@property(nonatomic, assign) CGFloat gaugeValue;
@property(nonatomic, assign) CGFloat gaugeAngle;

@property(nonatomic, assign) CGFloat anglePerValue;

@end

@implementation SYSpeedGaugeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _minNum = 0.0f;
    _maxNum = 220;
    
    
    _minAngle = -130;
    _maxAngle = 130;
    
    _gaugeValue = 0.0f;
    _gaugeAngle = -130;
    
    _anglePerValue = (_maxAngle - _minAngle)/(_maxNum - _minNum);
    
    
    _bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70 * SCALE_H, 60 * SCALE_H)];
    _bg.contentMode = UIViewContentModeScaleAspectFill;
    _bg.image = [UIImage imageNamed:@"gauge_speed"];
    [self addSubview:_bg];
    
//    _pointer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 32 * SCALE_H)];
//    _pointer.center = CGPointMake(35 * SCALE_H, 35 * SCALE_H);
//    _pointer.image = [UIImage imageNamed:@"gauge_speed_pointer"];
//    _pointer.layer.anchorPoint = CGPointMake(0.05, 0.95);
//    _pointer.transform = CGAffineTransformMakeScale(1, 1);
//    [self addSubview:_pointer];
    
    _dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    _dot.center = CGPointMake(35 * SCALE_H, 35 * SCALE_H);
    _dot.backgroundColor = TAB_SELECTED_COLOR;
    _dot.layer.cornerRadius = 2.5;
    _dot.layer.masksToBounds = YES;
    [self addSubview:_dot];
    
    _pointer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.5, 35 * SCALE_H)];
    _pointer.backgroundColor = TAB_SELECTED_COLOR;
    _pointer.center = CGPointMake(35 * SCALE_H, 35 * SCALE_H);
    _pointer.layer.anchorPoint = CGPointMake(0.5, 0.95);
    _pointer.transform = CGAffineTransformMakeScale(1, 1);
    [self addSubview:_pointer];

    
     //设置指针到0位置
    _pointer.layer.transform = CATransform3DMakeRotation([self transToRadian:_minAngle], 0, 0, 1);
    
    return self;
}

- (void)setGaugeValue:(CGFloat)value animation:(BOOL)animation {
    CGFloat tempAngle = [self parseAngleFromValue:value];
    _gaugeValue = value;
    //设置转动时间和转动动画
    if(animation){
        [self pointToAngle:tempAngle duration:0.6f];
    } else {
        [self pointToAngle:tempAngle duration:0.0f];
    }
}


- (void)pointToAngle:(CGFloat)angle duration:(CGFloat)duration {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    anim.duration = duration;
    anim.autoreverses = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion= NO;
    
    CGFloat distance = angle / 10;
    // 设置转动路径，不能直接用 CABaseAnimation 的toValue，那样是按最短路径的，转动超过180度时无法控制方向
    int i = 1;
    for (;i <= 10; i++) {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(_gaugeAngle + distance * i)], 0, 0, 1)]];
    }
    // 添加缓动效果
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(_gaugeAngle + distance * (i))], 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(_gaugeAngle + distance * (i - 2))], 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(_gaugeAngle + distance * (i-1))], 0, 0, 1)]];
    
    anim.values=values;
    [_pointer.layer addAnimation:anim forKey:@"cubeIn"];
    
    _gaugeAngle = _gaugeAngle + angle;
}

/**
 *  角度转弧度
 *
 *  @param angle
 *
 *  @return
 */
- (CGFloat)transToRadian:(CGFloat)angle {
    return angle * M_PI / 180;
}

/**
 *  值转角度
 *
 *  @param value
 *
 *  @return
 */
- (CGFloat)parseAngleFromValue:(CGFloat)value {
    if(value < _minNum){
        value =  _minNum;
    }else if(value > _maxNum){
        value = _maxNum;
    }
    CGFloat angle =(value - _gaugeValue) * _anglePerValue;
    return angle;
}



@end
