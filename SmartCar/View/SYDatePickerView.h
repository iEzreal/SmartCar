//
//  SYDatePickerView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/13.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYDatePickerView;

@protocol SYDatePickerViewDelegate <NSObject>

- (void)pickerView:(SYDatePickerView *)pickerView didSelectAtIndex:(NSInteger)index;

@end

@interface SYDatePickerView : UIView

@property(nonatomic, weak) id<SYDatePickerViewDelegate> delegate;

@property(nonatomic, assign) BOOL isShow;
@property(nonatomic, strong) NSArray *dataSourceArray;

- (void)showWithView:(UIView *)superView;
- (void)dismiss;

@end
