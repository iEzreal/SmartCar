//
//  SYMainNavView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/28.
//  Copyright © 2016年 liuyiming. All rights reserved.
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
