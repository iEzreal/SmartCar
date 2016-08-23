//
//  SYProgressView.h
//  ProgressViewDemo
//
//  Created by xxx on 16/6/30.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYProgressView : UIView

@property(nonatomic, strong) UIColor *trackColor;
@property(nonatomic, strong) UIColor *progressColor;

@property(nonatomic, assign) NSInteger trackLineWidth;
@property(nonatomic, assign) NSInteger progressLineWidth;


- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
