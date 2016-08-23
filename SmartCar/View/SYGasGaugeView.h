//
//  SYGasGaugeView.h
//  SmartCar
//
//  Created by xxx on 16/7/26.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGasGaugeView : UIView

@property (nonatomic, assign) NSInteger rate; // 中间显示的数字

- (void)startAnimation; // 开始动画

@end
