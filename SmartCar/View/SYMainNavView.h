//
//  SYMainNavView.h
//  SmartCar
//
//  Created by liuyiming on 16/7/28.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYMainNavView;
@protocol SYMainNavViewDelegate <NSObject>

- (void)mainNavView:(SYMainNavView *)mainNavView didSelectAtIndex:(NSUInteger)index;

@end

@interface SYMainNavView : UIView

@property(nonatomic, strong) NSString *titleStr;
@property(nonatomic, strong) NSString *locationStr;

@property(nonatomic, weak) id<SYMainNavViewDelegate> delegate;

@end
