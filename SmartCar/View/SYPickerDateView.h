//
//  SYPickerDateView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/15.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYPickerDateView;

@protocol SYPickerDateViewDelegate <NSObject>

- (void)datePickerView:(SYPickerDateView *)datePickerView didSelectStartYear:(NSString *)startYear startMonth:(NSString *)startMonth endYear:(NSString *)endYear endMonth:(NSString *)endMonth;

@end

@interface SYPickerDateView : UIView

@property(nonatomic, weak) id<SYPickerDateViewDelegate> delegate;

@property(nonatomic, assign) BOOL isShow;
- (void)show;

@end
