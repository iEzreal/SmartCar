//
//  SYHomeAlarmView.h
//  SmartCar
//
//  Created by liuyiming on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYHomeAlarmViewDelegate <NSObject>

- (void)moreAlarmAction;

@end

@interface SYHomeAlarmView : UIView

@property(nonatomic, weak) id<SYHomeAlarmViewDelegate> delegate;
@property(nonatomic, strong) NSArray *alarmArray;

@end
