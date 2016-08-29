//
//  SYLoginController.m
//  SmartCar
//
//  Created by xxx on 16/7/5.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYLoginController.h"
#import "SYForgotPwdController.h"
#import "SYRootController.h"
#import "AppDelegate.h"

#import "SYMainController.h"

#import "SYUser.h"
#import "SYVehicle.h"

@interface SYLoginController ()

@property(nonatomic, strong) UIImageView *bgImgView;

@property(nonatomic, strong) UIImageView *titleView;
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIImageView *logoIV;

@property(nonatomic, strong) UIImageView *userNameBgIV;
@property(nonatomic, strong) UIImageView *userNameIV;
@property(nonatomic, strong) UITextField *userNameTF;

@property(nonatomic, strong) UIImageView *userPwdBgIV;
@property(nonatomic, strong) UIImageView *userPwdIV;
@property(nonatomic, strong) UITextField *userPwdTF;

@property(nonatomic, strong) UIButton *rememberPwdBtn;
@property(nonatomic, strong) UIButton *forgetPwdBtn;

@property(nonatomic, strong) UIButton *loginBtn;

@end

@implementation SYLoginController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPageSubviews];
    [self layoutPageSubviews];
    [self readUserInfo];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 登陆
- (void)login {
    if ([_userNameTF.text isEqualToString:@""]) {
        [SYUtil showHintWithStatus:@"用户名不能为空" duration:2];
        return;
    }
    
    if ([_userPwdTF.text isEqualToString:@""]) {
        [SYUtil showHintWithStatus:@"密码不能为空" duration:2];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_userNameTF.text forKey:@"userName"];
    [dic setObject:_userPwdTF.text forKey:@"userPwd"];
    
    [SYUtil showWithStatus:@"正在登录..."];
    [SYApiServer login:dic success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"UserLoginResult"] integerValue] == 1) {
            [self parseUserWithJsonString:[responseDic objectForKey:@"UserInfo"]];
            [self parseVehicleWithJsonString:[responseDic objectForKey:@"VehicleInfo"]];
            
            SYMainController *mianController = [[SYMainController alloc] init];
            [self.navigationController pushViewController:mianController animated:YES];
            
            [SYUtil dismissProgressHUD];
            
        } else {
            [SYUtil showErrorWithStatus:@"登陆失败" duration:2];
        }
    } failure:^(NSError *error) {
         [SYUtil showErrorWithStatus:@"登陆失败" duration:2];
    }];
}

- (void)parseUserWithJsonString:(NSString *)jsonString {
    NSDictionary *userDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [userDic objectForKey:@"TableInfo"];
    NSDictionary *dic = tableArray[0];
    SYUser *user = [[SYUser alloc] initWithDic:dic];
    user.password = _userPwdTF.text;
    user.loginTime = [SYUtil currentDate];
    [SYAppManager sharedManager].user = user;
    [self saveUserInfo];
}

- (void)parseVehicleWithJsonString:(NSString *)jsonString {
    NSDictionary *vehicleDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [vehicleDic objectForKey:@"TableInfo"];
    [[SYAppManager sharedManager].vehicleArray removeAllObjects];
    for (int i = 0; i < tableArray.count; i++) {
        SYVehicle *vehicle = [[SYVehicle alloc] initWithDic:tableArray[i]];
        [[SYAppManager sharedManager].vehicleArray addObject:vehicle];
    }
}

// 读取用户信息
- (void)readUserInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"userName"]) {
        _userNameTF.text = [userDefaults objectForKey:@"userName"];
    }
    
    if ([userDefaults objectForKey:@"userPwd"]) {
        _userPwdTF.text = [userDefaults objectForKey:@"userPwd"];
        _rememberPwdBtn.selected = YES;
    }

}

// 保存用户信息
- (void)saveUserInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_userNameTF.text forKey:@"userName"];
    if (_rememberPwdBtn.isSelected) {
        [userDefaults setObject:_userPwdTF.text forKey:@"userPwd"];
    }
    [userDefaults synchronize];
}

#pragma mark - 事件处理
- (void)onClickAction:(UIButton *)sender {
    if (sender.tag == 200) {
        if (_rememberPwdBtn.isSelected) {
            _rememberPwdBtn.selected = NO;
        } else {
            _rememberPwdBtn.selected = YES;
        }
        
    } else if (sender.tag == 201) {
        if (![_userNameTF.text isEqualToString:@""]) {
            SYForgotPwdController *resetPwdController = [[SYForgotPwdController alloc] init];
            resetPwdController.loginName = _userNameTF.text;
            [self.navigationController pushViewController:resetPwdController animated:YES];
        } else {
            [SYUtil showHintWithStatus:@"请输入用户名" duration:2];
        }
    } else {
        [self login];
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - 界面UI
- (void)setupPageSubviews {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.userInteractionEnabled = YES;
    _bgImgView.image = [UIImage imageNamed:@"login_bg"];
    [_bgImgView addGestureRecognizer:tapGesture];
    [self.view addSubview:_bgImgView];
    
    _titleView = [[UIImageView alloc] init];
    _titleView.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:_titleView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"智能车联-用户登录";
    [self.view addSubview:_titleLabel];
    
    _logoIV = [[UIImageView alloc] init];
    _logoIV.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_logoIV];
    
    // 用户名
    _userNameBgIV = [[UIImageView alloc] init];
    _userNameBgIV.layer.borderColor = [UIColor whiteColor].CGColor;
    _userNameBgIV.layer.borderWidth = 0.5;
    _userNameBgIV.layer.cornerRadius = 18;
    _userNameBgIV.layer.masksToBounds = YES;
    [self.view addSubview:_userNameBgIV];
    
    _userNameIV = [[UIImageView alloc] init];
    _userNameIV.image = [UIImage imageNamed:@"login_name_icon"];
    [self.view addSubview:_userNameIV];
    
    _userNameTF = [[UITextField alloc] init];
    _userNameTF.textColor = [UIColor whiteColor];
    _userNameTF.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_userNameTF];
    
    
    // 密码
    _userPwdBgIV = [[UIImageView alloc] init];
    _userPwdBgIV.layer.borderColor = [UIColor whiteColor].CGColor;
    _userPwdBgIV.layer.borderWidth = 0.5;
    _userPwdBgIV.layer.cornerRadius = 18;
    _userPwdBgIV.layer.masksToBounds = YES;
    [self.view addSubview:_userPwdBgIV];
    
    _userPwdIV = [[UIImageView alloc] init];
    _userPwdIV.image = [UIImage imageNamed:@"login_pwd_icon"];
    [self.view addSubview:_userPwdIV];
    
    _userPwdTF = [[UITextField alloc] init];
    _userPwdTF.secureTextEntry = YES;
    _userPwdTF.textColor = [UIColor whiteColor];
    _userPwdTF.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_userPwdTF];
    
    // 记住密码
    _rememberPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rememberPwdBtn setImage:[UIImage imageNamed:@"remb_pwd_uncheck"] forState:UIControlStateNormal];
    [_rememberPwdBtn setImage:[UIImage imageNamed:@"remb_pwd_check"] forState:UIControlStateSelected];
    _rememberPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rememberPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rememberPwdBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [_rememberPwdBtn addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _rememberPwdBtn.tag = 200;
    [self.view addSubview:_rememberPwdBtn];
    
    // 忘记密码
    _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_forgetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_forgetPwdBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPwdBtn addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _forgetPwdBtn.tag = 201;
    [self.view addSubview:_forgetPwdBtn];
    
    // 登陆
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.layer.cornerRadius = 18;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"4EB8CD"]] forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitle:@"LOGIN IN | 登陆" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.tag = 202;
    [self.view addSubview:_loginBtn];
}

- (void)layoutPageSubviews {
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleView).offset(6);
        make.centerY.equalTo(_titleView);
    }];
    
    [_logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom).offset(70);
        make.centerX.equalTo(self.view);
    }];
    
    // 用户名
    [_userNameBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoIV.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@36);
    }];
    
    [_userNameIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameBgIV).offset(10);
        make.centerY.equalTo(_userNameBgIV);
        make.width.equalTo(@10);
        make.height.equalTo(@15);
        
    }];
    
    [_userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameIV.mas_right).offset(5);
        make.right.equalTo(_userNameBgIV).offset(-5);
        make.centerY.equalTo(_userNameBgIV);
    }];
    
    // 用户密码
    [_userPwdBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameBgIV.mas_bottom).offset(20);
        make.left.right.height.equalTo(_userNameBgIV);
    }];
    
    [_userPwdIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userPwdBgIV).offset(10);
        make.centerY.equalTo(_userPwdBgIV);
        
    }];
    
    [_userPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userPwdIV.mas_right).offset(5);
        make.right.equalTo(_userPwdBgIV);
        make.centerY.equalTo(_userPwdBgIV);
    }];
    
    // 记住密码
    [_rememberPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userPwdBgIV.mas_bottom).offset(10);
        make.left.equalTo(_userPwdBgIV.mas_left).offset(10);
    }];
    
    // 忘记密码
    [_forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_userPwdBgIV).offset(-10);
        make.centerY.equalTo(_rememberPwdBtn);
    }];
    
    // 登陆
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userPwdBgIV.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.width.equalTo(_userPwdBgIV);
        make.height.equalTo(@36);
    }];

}


@end
