//
//  SYHomeController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeController.h"
#import "SYCarSwitchView.h"

@interface SYHomeController () <SYCarSwitchViewDelegate>

@property(nonatomic, strong) UIButton *navTitleBtn;
@property(nonatomic, strong) UIButton *locationBtn;

@property(nonatomic, strong) SYCarSwitchView *carSwitchView;

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *carParameterView;
@property(nonatomic, strong) UIView *carOilGaugeView;
@property(nonatomic, strong) UIView *carSpeedGaugeView;
@property(nonatomic, strong) UIView *carSvoltageGaugeView;



@end

@implementation SYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _navTitleBtn.frame = CGRectMake(0, 0, 120, 44);
    [_navTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_navTitleBtn setTitle:@"沪A992E1" forState:UIControlStateNormal];
    [_navTitleBtn addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _navTitleBtn.tag = 100;
    self.navigationItem.titleView = _navTitleBtn;
    
    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.frame = CGRectMake(0, 0, 60, 44);
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_locationBtn setTitle:@"上海市" forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _locationBtn.tag = 101;
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _carParameterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    _carParameterView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_carParameterView];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_carParameterView.frame), self.view.frame.size.width, 300)];
    view2.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame), self.view.frame.size.width, 300)];
    view3.backgroundColor = [UIColor yellowColor];
    [_scrollView addSubview:view3];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(view3.frame));
    
}

#pragma mark - SYCarSwitchViewDelegate
- (void)carSwitchView:(SYCarSwitchView *)carSwitchView didSelectRowAtIndex:(NSInteger)index {
    
    NSLog(@"-----------%ld", index);
}


#pragma mark - 按钮点击事件
- (void)homeButtonAction:(UIButton *)sender {
    if (sender.tag == 100) {
        if (!_carSwitchView) {
            _carSwitchView = [[SYCarSwitchView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)];
            _carSwitchView.delegate = self;
            
        }
        
        if (_carSwitchView.isShow) {
            [_carSwitchView hide];
        } else {
            [_carSwitchView setSRCArray:@[@"1huhuhhhui", @"2gyugkug", @"3", @"4"]];
            [_carSwitchView showWithView:self.view];
        }
    } else {
        NSLog(@"===== 位置切换 =====");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
