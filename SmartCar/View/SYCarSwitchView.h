//
//  SYCarSwitchView.h
//  SmartCar
//
//  Created by liuyiming on 16/6/29.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>


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

@interface  SYCarSwitchViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *contentLabel;

@end
