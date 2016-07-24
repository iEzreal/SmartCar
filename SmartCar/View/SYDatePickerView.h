//
//  SYDatePickerView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/15.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYDatePickerView;

@protocol SYDatePickerViewDelegate <NSObject>

- (void)datePickerView:(SYDatePickerView *)datePickerView didSelectStartYear:(NSString *)startYear startMonth:(NSString *)startMonth endYear:(NSString *)endYear endMonth:(NSString *)endMonth;

@end

@interface SYDatePickerView : UIView

@property(nonatomic, weak) id<SYDatePickerViewDelegate> delegate;

@property(nonatomic, assign) BOOL isShow;
- (void)show;

@end
