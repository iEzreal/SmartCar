//
//  SYHomeCarPhysicalView.h
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CheckPhysicalBlock)();

@interface SYHomeCarPhysicalView : UIView

@property(nonatomic, copy) CheckPhysicalBlock block;

@end
