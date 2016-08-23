//
//  SYPickerAlertView.h
//  SmartCar
//
//  Created by xxx on 16/6/29.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYPickerAlertView;
@protocol SYPickerAlertViewDelegate <NSObject>

- (void)pickerAlertView:(SYPickerAlertView *)pickerAlertView didSelectAtIndex:(NSInteger)index;

@end

@interface SYPickerAlertView : UIView

@property(nonatomic, weak) id<SYPickerAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title dataArray:(NSArray *)dataArray;
- (void)show;

@end
