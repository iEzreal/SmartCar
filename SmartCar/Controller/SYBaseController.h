//
//  SYBaseController.h
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYBaseController : UIViewController

@property(nonatomic, strong) NSString *locationStr;

- (void)returnToPrevController;

@end
