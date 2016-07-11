//
//  SYMineMenuCell.h
//  SmartCar
//
//  Created by liuyiming on 16/7/9.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuClickBlock)(NSInteger index);

@interface SYMineMenuCell : UITableViewCell

@property(nonatomic, copy) MenuClickBlock block;

@end
