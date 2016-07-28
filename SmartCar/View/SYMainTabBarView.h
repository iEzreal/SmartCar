//
//  SYMainTabBarView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/28.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYMainTabBarView;
@protocol SYMainTabBarViewDelegate <NSObject>

- (void)mainTabBarView:(SYMainTabBarView *)tabBarView didSelectAtIndex:(NSInteger )index;

@end

@interface SYMainTabBarView : UIView

@property(nonatomic, weak)id <SYMainTabBarViewDelegate> delegate;

@end
