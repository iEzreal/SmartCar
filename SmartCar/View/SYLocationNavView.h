//
//  SYLocationNavView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/12.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYLocationNavViewDelegate <NSObject>

- (void)switchWithIndex:(NSInteger )index;

@end

@interface SYLocationNavView : UIView

@property(nonatomic, weak) id<SYLocationNavViewDelegate> delegate;

@end
