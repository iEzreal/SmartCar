//
//  SYMineMenuView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/23.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYMineMenuView;
@protocol SYMineMenuViewDelegate <NSObject>

- (void)menuView:(SYMineMenuView *)menuView didSelectedAtIndex:(NSInteger)index;

@end

@interface SYMineMenuView : UIView

@property(nonatomic, weak) id<SYMineMenuViewDelegate> deleagate;

@end
