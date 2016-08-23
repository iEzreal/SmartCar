//
//  SYPickerDateView.h
//  SmartCar
//
//  Created by xxx on 16/7/15.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYPickerDateView;

@protocol SYPickerDateViewDelegate <NSObject>

- (void)datePickerView:(SYPickerDateView *)datePickerView didSelectStartMonth:(NSInteger)startMonth startDay:(NSInteger)startDay endMonth:(NSInteger)endMonth endDay:(NSInteger)endDay;

@end

@interface SYPickerDateView : UIView

@property(nonatomic, weak) id<SYPickerDateViewDelegate> delegate;

@property(nonatomic, assign) BOOL isShow;
- (void)show;

@end
