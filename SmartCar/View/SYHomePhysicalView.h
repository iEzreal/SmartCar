//
//  SYHomePhysicalView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYHomePhysicalViewDelegate <NSObject>

- (void)morePhysicalAction;

@end


@interface SYHomePhysicalView : UIView

@property(nonatomic, weak) id<SYHomePhysicalViewDelegate> delegate;

@end
