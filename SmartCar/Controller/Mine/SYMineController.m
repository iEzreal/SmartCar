//
//  SYMineController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYMineController.h"
#import "SYChangePwdController.h"
#import "SYPersonalInfoController.h"
#import "SYPhysicalController.h"
#import "SYSettingMileageController.h"
#import "SYAboutController.h"
#import "SYVersionController.h"
#import "SYLoginController.h"
#import "AppDelegate.h"

#import "SYMineMenuView.h"

@interface SYMineController () <SYMineMenuViewDelegate>

@property(nonatomic, strong) UIImageView *bgIV;
@property(nonatomic, strong) UIImageView *userAvatarIV;
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UILabel *loginTimeLabel;
@property(nonatomic, strong) SYMineMenuView *menuView;

@end

@implementation SYMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPageSubviews];
    [self layoutPageSubviews];
    
    _userNameLabel.text = [SYAppManager sharedManager].user.userName;
    _loginTimeLabel.text = [NSString stringWithFormat:@"[%@]",[SYAppManager sharedManager].user.loginTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)returnToPrevController {
    [super returnToPrevController];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = [[SYLoginController alloc] init];
}

#pragma mark 代理方法
- (void)menuView:(SYMineMenuView *)menuView didSelectedAtIndex:(NSInteger)index {
    if (index == 0) {
        SYChangePwdController *pwdController = [[SYChangePwdController alloc] init];
        [self.navigationController pushViewController:pwdController animated:YES];
        
    } else if (index == 1) {
        SYPersonalInfoController *infoController = [[SYPersonalInfoController alloc] init];
        [self.navigationController pushViewController:infoController animated:YES];
        
    } else if (index == 2) {
        SYSettingMileageController *mileageController = [[SYSettingMileageController alloc] init];
        [self.navigationController pushViewController:mileageController animated:YES];
        
    } else if (index == 3) {
        SYPhysicalController *physicalController = [[SYPhysicalController alloc] init];
        [self.navigationController pushViewController:physicalController animated:YES];
        
    } else if (index == 4) {
        SYAboutController *aboutController = [[SYAboutController alloc] init];
        [self.navigationController pushViewController:aboutController animated:YES];
       
    } else {
        SYVersionController *versionController = [[SYVersionController alloc] init];
        [self.navigationController pushViewController:versionController animated:YES];
    }
}

#pragma mark - 界面UI
- (void)setPageSubviews {
    _bgIV = [[UIImageView alloc] init];
    _bgIV.image = [UIImage imageNamed:@"mine_bg"];
    [self.view addSubview:_bgIV];
    
    _userAvatarIV = [[UIImageView alloc] init];
    _userAvatarIV.image = [UIImage imageNamed:@"user_photo"];
    [self.view addSubview:_userAvatarIV];
    
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.font = [UIFont systemFontOfSize:22];
    _userNameLabel.textColor = TAB_SELECTED_COLOR;
    [self.view addSubview:_userNameLabel];
    
    _loginTimeLabel = [[UILabel alloc] init];
    _loginTimeLabel.font = [UIFont systemFontOfSize:16];
    _loginTimeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_loginTimeLabel];
    
    _menuView = [[SYMineMenuView alloc] init];
    _menuView.deleagate = self;
    [self.view addSubview:_menuView];
}

- (void)layoutPageSubviews {
    [_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userAvatarIV.mas_centerY);
        make.left.right.bottom.equalTo(self.view);
        
    }];
    
    [_userAvatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.centerX.equalTo(self.view);
        
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userAvatarIV.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
        
    }];
    
    [_loginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        
    }];
    
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginTimeLabel.mas_bottom).offset(6);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(SCREEN_W - 40));
        make.height.equalTo(@((SCREEN_W - 40) / 3 * 2));
    }];
    
    [_menuView addTopBorderWithColor:[UIColor colorWithWhite:1 alpha:0.8] width:0.5];
    [_menuView addBottomBorderWithColor:[UIColor colorWithWhite:1 alpha:0.8] width:0.5];
}


@end
