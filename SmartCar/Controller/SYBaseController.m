//
//  SYBaseController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYBaseController.h"
#import "SYPickerAlertView.h"

@interface SYBaseController ()

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) SYButton *titleBtn;
@property(nonatomic, strong) SYButton *locationBtn;

@property(nonatomic, strong) SYPickerAlertView *pickerAlertView;

@end

@implementation SYBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
