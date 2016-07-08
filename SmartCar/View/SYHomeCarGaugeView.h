//
//  SYHomeCarGaugeView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)();

@interface SYHomeCarGaugeView : UIView

@property(nonatomic, copy) RefreshBlock block;

@property(nonatomic, strong) NSString *refreshTimeText;
@property(nonatomic, strong) NSString *oilText;
@property(nonatomic, strong) NSString *speedText;
@property(nonatomic, strong) NSString *stateText;
@property(nonatomic, strong) NSString *voltageText;
@property(nonatomic, strong) NSString *mileageText;

- (void)endRefresh;

@end
