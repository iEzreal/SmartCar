//
//  SYHomeMenuCell.h
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuBlock)(NSInteger index);

@interface SYHomeMenuCell : UITableViewCell

@property(nonatomic, copy) MenuBlock block;

- (void)setMapPointWithLat:(CGFloat)lat lon:(CGFloat)lon;

@end
