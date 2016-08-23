//
//  SYProgressView.m
//  ProgressViewDemo
//
//  Created by xxx on 16/6/30.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYProgressView.h"

#define CATDegreesToRadians(x) (M_PI*(x)/180.0)
#define TRACK_LINE_W 4
#define PROGRESS_LINE_W 6

@interface SYProgressView ()

@property(nonatomic, strong) CAShapeLayer *trackLayer;
@property(nonatomic, strong) CAShapeLayer *progressLayer;
@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, assign) CGFloat lastProgress;
@property(nonatomic, assign) CGFloat progress;


@end

@implementation SYProgressView


- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return self;
    }
    
    _trackLayer = [CAShapeLayer layer];
    _trackLayer.frame = self.bounds;
    _trackLayer.fillColor = [UIColor clearColor].CGColor;
    _trackLayer.strokeColor = [UIColor colorWithHexString:@"50586c"].CGColor;
    _trackLayer.lineCap = kCALineCapSquare;
    _trackLayer.lineWidth = TRACK_LINE_W;
    [self.layer addSublayer:_trackLayer];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor = [UIColor colorWithHexString:@"4EB7CD"].CGColor;
    _progressLayer.lineCap = kCALineCapSquare;
    _progressLayer.lineWidth = PROGRESS_LINE_W;
    _progressLayer.strokeEnd = 0.0;
    [self.layer addSublayer:_progressLayer];

    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"oil_logo"];
    [self addSubview:_imageView];
    
    [self setPath];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _trackLayer.frame = self.bounds;
    _progressLayer.frame = self.bounds;
    _imageView.frame = CGRectMake(0, 0, 20, 20);
    _imageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self setPath];
}

- (void)setPath{
    CGFloat trackRadius = self.frame.size.width / 2 - TRACK_LINE_W - 2;
    UIBezierPath *trackPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:trackRadius startAngle:CATDegreesToRadians(270) endAngle:CATDegreesToRadians(630) clockwise:YES];
    _trackLayer.path = trackPath.CGPath;
    
    CGFloat progressRadius = self.frame.size.width / 2 - PROGRESS_LINE_W;
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:progressRadius startAngle:CATDegreesToRadians(270) endAngle:CATDegreesToRadians(630) clockwise:YES];
    _progressLayer.path = progressPath.CGPath;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    progress = progress < 0.0f ? 0.0f : progress;
    progress = progress > 1.0f ? 1.0f : progress;
    _lastProgress = _progress;
    _progress = progress;
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:1];
    progress = progress < 0.0 ? 0.0 : progress;
    progress = progress > 1.0 ? 1.0 : progress;
    _progressLayer.strokeEnd = progress;
    [CATransaction commit];
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    _trackLayer.strokeColor = _trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    _progressLayer.strokeColor = _progressColor.CGColor;
}

- (void)setTrackLineWidth:(NSInteger)trackLineWidth {
    _trackLineWidth = trackLineWidth;
    _trackLayer.lineWidth = _trackLineWidth;
}


@end
