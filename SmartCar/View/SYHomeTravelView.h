//
//  SYHomeTravelView.h
//  SmartCar
//
//  Created by xxx on 16/7/18.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYHomeTravelViewDelegate <NSObject>

- (void)moreTraveAction;

@end

@interface SYHomeTravelView : UIView

@property(nonatomic, weak) id<SYHomeTravelViewDelegate> delegate;
@property(nonatomic, strong) NSMutableArray *travelArray;

@end
