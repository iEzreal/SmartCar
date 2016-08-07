//
//  SYCarSwitchView.h
//  SmartCar
//
//  Created by liuyiming on 16/6/29.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYBaseCell.h"

@class SYCarSwitchView;
@protocol SYCarSwitchViewDelegate <NSObject>

- (void)carSwitchView:(SYCarSwitchView *)carSwitchView didSelectRowAtIndex:(NSInteger)index;

@end

@interface SYCarSwitchView : UIView

@property(nonatomic, weak) id<SYCarSwitchViewDelegate> delegate;
@property(nonatomic, assign, getter=isShow) BOOL show;

- (void)setSRCArray:(NSArray *)sourceArray;
- (void)showWithView:(UIView *)superView;
- (void)hide;

@end

@interface  SYCarSwitchViewCell : SYBaseCell

@property(nonatomic, strong) UILabel *contentLabel;

@end
