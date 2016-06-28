//
//  SYRootController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYRootController.h"
#import "SYNavigationController.h"
#import "SYHomeController.h"
#import "SYStatController.h"
#import "SYMineController.h"

@interface SYRootController ()

@end

@implementation SYRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupChildController {
    [self addChildController:[[SYHomeController alloc] init] title:@"首页" image:@"home_normal" selectedImage:@"home_selected"];
    [self addChildController:[[SYStatController alloc] init] title:@"统计" image:@"stat_normal" selectedImage:@"stat_selected"];
    [self addChildController:[[SYMineController alloc] init] title:@"我" image:@"mine_normal" selectedImage:@"mine_selected"];
}


- (void)addChildController:(UIViewController *)controller
                     title:(NSString *)title
                     image:(NSString *)image
             selectedImage:(NSString *)selectedImage {
    
    controller.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:image];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateNormal];
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} forState:UIControlStateSelected];
    
    SYNavigationController *navController = [[SYNavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:navController];
}



@end
