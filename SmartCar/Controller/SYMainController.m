//
//  SYMainController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/28.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYMainController.h"
#import "SYHomeController.h"
#import "SYStatController.h"
#import "SYMineController.h"

#import "SYMainNavView.h"
#import "SYMainTabBarView.h"

@interface SYMainController () <SYMainNavViewDelegate, SYMainTabBarViewDelegate>

@property(nonatomic, strong) SYMainNavView *navView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) SYMainTabBarView *tabBarView;

@property(nonatomic, assign) NSInteger showIndex;

@property(nonatomic, strong) NSArray *childControllers;
@property(nonatomic, strong) UINavigationController *homeNavController;
@property(nonatomic, strong) UINavigationController *statNavController;
@property(nonatomic, strong) UINavigationController *mineNavController;

@property(nonatomic, strong) SYHomeController *homeController;
@property(nonatomic, strong) SYStatController *statController;
@property(nonatomic, strong) SYMineController *mineController;

@end

@implementation SYMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *statusBarBG= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 20)];
    statusBarBG.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarBG];
    
    _navView = [[SYMainNavView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, 44)];
    _navView.backgroundColor = NAV_BG_COLOR;
    _navView.delegate = self;
    [self.view addSubview:_navView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 49)];
    _contentView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_contentView];
    
    _tabBarView = [[SYMainTabBarView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 49, SCREEN_W, 49)];
    _tabBarView.backgroundColor = [UIColor blackColor];
    _tabBarView.delegate = self;
    [self.view addSubview:_tabBarView];
    
    _homeController = [[SYHomeController alloc] init];
    _homeNavController = [[UINavigationController alloc] initWithRootViewController:_homeController];
    
     UIStoryboard *statStoryBoard = [UIStoryboard storyboardWithName:@"SYStatController" bundle:nil];
    _statController = [statStoryBoard instantiateViewControllerWithIdentifier:@"SYStatController"];
    _statNavController = [[UINavigationController alloc] initWithRootViewController:_statController];
    
    _mineController = [[SYMineController alloc] init];
    _mineNavController = [[UINavigationController alloc] initWithRootViewController:_mineController];
    
    _childControllers = @[_homeNavController, _statNavController, _mineNavController];
    
    [self addChildViewController:_homeNavController];
    [_contentView addSubview:_homeNavController.view];
    
    // 更新定位通知接受
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateLocationInfo:) name:notification_update_Location object:nil];
    
    //
    _navView.titleStr = [SYAppManager sharedManager].vehicle.carNum;
   
    
}

- (void)updateLocationInfo:(NSNotification *)sender {
    NSString *locationStr = [sender.userInfo objectForKey:@"location"];
     _navView.locationStr = locationStr;
    
}

- (void)mainNavView:(SYMainNavView *)mainNavView didSelectAtIndex:(NSUInteger)index {
    // 返回事件
    if (index == 0) {
        // 首页
        if (_showIndex == 0) {
            if (_homeNavController.topViewController == _homeController) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [_homeNavController popViewControllerAnimated:YES];
            }
        }
        
        // 统计
        else if (_showIndex == 1) {
            if (_statNavController.topViewController == _statController) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [_statNavController popViewControllerAnimated:YES];
            }
        }
        
        // 我的
        else {
            if (_mineNavController.topViewController == _mineController) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [_mineNavController popViewControllerAnimated:YES];
            }
        }
    }
    
    // 车辆切换
    else if (index == 0) {
    
    }
}

- (void)mainTabBarView:(SYMainTabBarView *)tabBarView didSelectAtIndex:(NSInteger )index {
    _showIndex = index;
    [self showControllerWithShowIndex:index];
}

- (void)showControllerWithShowIndex:(NSInteger)showIndex {
    for (int i = 0; i < _childControllers.count; i ++) {
        if (i == showIndex) {
            [self addChildViewController:_childControllers[i]];
            [_contentView addSubview:[_childControllers[i] view]];
            [_childControllers[i] popToRootViewControllerAnimated:YES];
        } else {
            [[_childControllers[i] view] removeFromSuperview];
            [_childControllers[i] removeFromParentViewController];
        }
    }
}


@end
