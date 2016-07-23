//
//  SYPickerAlertView.h
//  SmartCar
//
//  Created by liuyiming on 16/6/29.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYPickerAlertView;
@protocol SYPickerAlertViewDelegate <NSObject>

- (void)pickerAlertView:(SYPickerAlertView *)pickerAlertView didSelectAtIndex:(NSInteger)index;

@end

@interface SYPickerAlertView : UIView

@property(nonatomic, weak) id<SYPickerAlertViewDelegate> delegate;

- (instancetype)initDataArray:(NSArray *)dataArray;
- (void)show;

@end
