//
//  SYPageTopView.h
//  SmartCar
//
//  Created by liuyiming on 16/7/22.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYPageTopViewDelegate <NSObject>

- (void)topViewRightAction;

@end

@interface SYPageTopView : UIView

@property(nonatomic, strong) UIColor *BGColor;
@property(nonatomic, strong) UIImage *iconImage;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) UIButton *rightBtn;

@property(nonatomic, weak) id <SYPageTopViewDelegate> delegate;

@end
