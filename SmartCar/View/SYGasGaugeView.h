//
//  SYGasGaugeView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/26.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGasGaugeView : UIView

@property (nonatomic, assign) NSInteger rate; // 中间显示的数字

- (void)startAnimation; // 开始动画

@end
