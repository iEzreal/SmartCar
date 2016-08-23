//
//  SYHomeGaugeView.h
//  SmartCar
//
//  Created by xxx on 16/7/4.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYHomeGaugeViewDelegate <NSObject>

- (void)refreshPositionAction;

@end

@interface SYHomeGaugeView : UIView

@property(nonatomic, weak) id <SYHomeGaugeViewDelegate> delegate;

@property(nonatomic, strong) NSString *refreshTimeText;
@property(nonatomic, strong) NSString *oilText;
@property(nonatomic, strong) NSString *speedText;
@property(nonatomic, strong) NSString *stateText;
@property(nonatomic, strong) NSString *voltageText;
@property(nonatomic, strong) NSString *mileageText;

- (void)finishRefresh;

@end
