//
//  SYLatestTravelHeaderView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYHomeMoreViewDelegate <NSObject>

- (void)moreAction;

@end

@interface SYHomeMoreView : UIView

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIImage *image;

@property(nonatomic, weak) id <SYHomeMoreViewDelegate> delegate;

@end
