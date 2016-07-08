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
    [self addChildController:[[SYHomeController alloc] init] title:@"首页" image:@"home_normal" selectedImage:@"home_normal"];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SYStatController" bundle:nil];
    [self addChildController:[storyBoard instantiateViewControllerWithIdentifier:@"SYStatController"] title:@"统计" image:@"static_normal" selectedImage:@"static_normal"];
    [self addChildController:[[SYMineController alloc] init] title:@"我" image:@"mine_normal" selectedImage:@"mine_normal"];
}


- (void)addChildController:(UIViewController *)controller
                     title:(NSString *)title
                     image:(NSString *)image
             selectedImage:(NSString *)selectedImage {
    
    controller.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CGSize indicatorImageSize = CGSizeMake(self.tabBar.bounds.size.width / 3, self.tabBar.bounds.size.height);
    
    self.tabBar.backgroundImage = [self drawTabBarItemBackgroundImageWithSize:indicatorImageSize red:62 green:58 blue:57];
    self.tabBar.selectionIndicatorImage = [self drawTabBarItemBackgroundImageWithSize:indicatorImageSize red:78 green:183 blue:205];
    
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    
    SYNavigationController *navController = [[SYNavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:navController];
}

- (UIImage *)drawTabBarItemBackgroundImageWithSize:(CGSize)size red:(CGFloat) red green:(CGFloat) green blue:(CGFloat)blue{
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, red / 255, green / 255, blue / 255, 1);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
