//
//  SYBaseController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYBaseController.h"

@interface SYBaseController ()

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) SYButton *titleBtn;
@property(nonatomic, strong) SYButton *locationBtn;

@end

@implementation SYBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    
    UIView *statusBarBG= [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_W, 20)];
    statusBarBG.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statusBarBG];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 50, 30);
    _backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(navBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.tag = 10000;
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    _titleBtn = [[SYButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44) image:[UIImage imageNamed:@"list_down"] title:[SYAppManager sharedManager].vehicle.carNum];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_titleBtn addTarget:self action:@selector(navBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _titleBtn.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentRight;
    _titleBtn.tag = 10001;
    self.navigationItem.titleView = _titleBtn;
    
    _locationBtn = [[SYButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44) image:[UIImage imageNamed:@"list_down"] title:@"上海"];
    _locationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    _locationBtn.imgTextDistance = 3;
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(navBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _locationBtn.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentRight;
    _locationBtn.tag = 10002;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBtn];
}

- (void)navBtnOnClick:(UIButton *)sender {
    if (sender.tag == 10000) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (sender.tag == 10001) {
    
    } else {
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
