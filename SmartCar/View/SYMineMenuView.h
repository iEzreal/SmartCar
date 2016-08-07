//
//  SYMineMenuView.h
//  SmartCar
//
//  Created by liuyiming on 16/7/23.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYMineMenuView;
@protocol SYMineMenuViewDelegate <NSObject>

- (void)menuView:(SYMineMenuView *)menuView didSelectedAtIndex:(NSInteger)index;

@end

@interface SYMineMenuView : UIView

@property(nonatomic, weak) id<SYMineMenuViewDelegate> deleagate;

@end
