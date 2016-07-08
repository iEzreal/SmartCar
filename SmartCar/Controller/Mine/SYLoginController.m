//
//  SYLoginController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYLoginController.h"
#import "SYRootController.h"
#import "AppDelegate.h"

#import "SYUser.h"
#import "SYVehicle.h"

@interface SYLoginController ()

@property(nonatomic, strong) UIImageView *bgImgView;

@property(nonatomic, strong) UIImageView *logoIV;

@property(nonatomic, strong) UIImageView *userNameBgIV;
@property(nonatomic, strong) UIImageView *userNameIV;
@property(nonatomic, strong) UITextField *userNameTF;

@property(nonatomic, strong) UIImageView *userPwdBgIV;
@property(nonatomic, strong) UIImageView *userPwdIV;
@property(nonatomic, strong) UITextField *userPwdTF;

@property(nonatomic, strong) UIButton *loginBtn;

@end

@implementation SYLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.userInteractionEnabled = YES;
    _bgImgView.image = [UIImage imageNamed:@"login_bg"];
    [_bgImgView addGestureRecognizer:tapGesture];
    [self.view addSubview:_bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _logoIV = [[UIImageView alloc] init];
    _logoIV.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_logoIV];
    [_logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
    }];
    
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
    _userPwdTF.textColor = [UIColor whiteColor];
    _userPwdTF.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_userPwdTF];
    
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
    
    [_userPwdBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameBgIV.mas_bottom).offset(10);
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


    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.layer.cornerRadius = 18;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.backgroundColor = [UIColor colorWithHexString:@"4EB8CD"];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitle:@"LOGIN IN | 登陆" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userPwdBgIV.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.width.equalTo(_userPwdBgIV);
        make.height.equalTo(@36);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)onClickAction:(UIButton *)sender {
    [self login];
}

- (void)login {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"sy003" forKey:@"userName"];
    [dic setObject:@"000000" forKey:@"userPwd"];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [SYApiServer login:dic success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        
        [self parseUserWithJsonString:[responseDic objectForKey:@"UserInfo"]];
        [self parseVehicleWithJsonString:[responseDic objectForKey:@"VehicleInfo"]];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = [[SYRootController alloc] init];
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"登陆失败"];
    }];
}

- (void)parseUserWithJsonString:(NSString *)jsonString {
    NSDictionary *userDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [userDic objectForKey:@"TableInfo"];
    NSDictionary *dic = tableArray[0];
    SYUser *user = [[SYUser alloc] initWithDic:dic];
    user.password = @"000000";
    [SYAppManager sharedManager].user = user;
}

- (void)parseVehicleWithJsonString:(NSString *)jsonString {
    NSDictionary *vehicleDic = [jsonString objectFromJSONString];
    NSArray *tableArray = [vehicleDic objectForKey:@"TableInfo"];
    NSDictionary *dic = tableArray[0];
    SYVehicle *vehicle = [[SYVehicle alloc] initWithDic:dic];
    [SYAppManager sharedManager].vehicle = vehicle;
    
}



- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


@end