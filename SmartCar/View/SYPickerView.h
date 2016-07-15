//
//  SYDatePickerView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/13.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYPickerView;

@protocol SYPickerViewDelegate <NSObject>

- (void)pickerView:(SYPickerView *)pickerView didSelectAtIndex:(NSInteger)index;

@end

@interface SYPickerView : UIView

@property(nonatomic, weak) id<SYPickerViewDelegate> delegate;

@property(nonatomic, assign) BOOL isShow;
@property(nonatomic, strong) NSArray *dataSourceArray;

- (void)showWithView:(UIView *)superView;
- (void)dismiss;

@end
