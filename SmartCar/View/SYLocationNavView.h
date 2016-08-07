//
//  SYLocationNavView.h
//  SmartCar
//
//  Created by liuyiming on 16/7/12.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYLocationNavViewDelegate <NSObject>

- (void)switchWithIndex:(NSInteger )index;

@end

@interface SYLocationNavView : UIView

@property(nonatomic, weak) id<SYLocationNavViewDelegate> delegate;

@end
