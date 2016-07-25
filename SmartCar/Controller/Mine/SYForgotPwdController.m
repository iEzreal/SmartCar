//
//  SYForgotPwdController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYForgotPwdController.h"

@interface SYForgotPwdController ()

@property(nonatomic, strong) UIView *authCodeView;
@property(nonatomic, strong) UILabel *authCodeLabel;
@property(nonatomic, strong) UITextField *authCodeTF;

@property(nonatomic, strong) UILabel *hintLabel;

@property(nonatomic, strong) UIButton *getAuthCodeBtn;
@property(nonatomic, strong) UIButton *confirmBtn;

@property(nonatomic, strong) UIView *pwd1View;
@property(nonatomic, strong) UILabel *pwd1Label;
@property(nonatomic, strong) UITextField *pwd1TF;

@property(nonatomic, strong) UIView *pwd2View;
@property(nonatomic, strong) UILabel *pwd2Label;
@property(nonatomic, strong) UITextField *pwd2TF;

@property(nonatomic, strong) UIButton *resetBtn;

@end

@implementation SYForgotPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = PAGE_BG_COLOR;
    
    UIView *statusBarBG= [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_W, 20)];
    statusBarBG.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statusBarBG];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, 30);
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    backBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 10000;
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    [self setupPageSubviews];
}

// 发送邮件获取认证码
- (void)sendMailForApprove {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:[@"17" integerValue]] forKey:@"userID"];
    [SYApiServer POST:METHOD_SEND_MAIL_FOR_APPROVE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic) {
            
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

// 邮件认证码验证
- (void)mailForApprovee:(NSString *)userId approveCode:(NSString *)approveCode {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:[userId integerValue]] forKey:@"userID"];
    [parameters setObject:approveCode forKey:@"approvecode"];

    [SYApiServer POST:METHOD_MAIL_FOR_APPROVE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic) {
            
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

// 重置密码
- (void)approveNewPwd:(NSString *)userId approveCode:(NSString *)approveCode newPwd:(NSString *)newPwd {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:[userId integerValue]] forKey:@"userID"];
    [parameters setObject:approveCode forKey:@"approvecode"];
    [parameters setObject:newPwd forKey:@"newPwd"];
    [SYApiServer POST:METHOD_APPROVE_NEWPWD parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic) {
            
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 事件处理
- (void)navBackBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - 界面UI
- (void)setupPageSubviews {
    _authCodeView = [[UIView alloc] init];
    _authCodeView.layer.borderColor = [UIColor whiteColor].CGColor;
    _authCodeView.layer.borderWidth = 0.5;
    _authCodeView.layer.cornerRadius = 18;
    [self.view addSubview:_authCodeView];
    
    _authCodeLabel = [[UILabel alloc] init];
    _authCodeLabel.font = [UIFont systemFontOfSize:15];
    _authCodeLabel.textColor = [UIColor whiteColor];
    _authCodeLabel.text = @"认证码：";
    [self.view addSubview:_authCodeLabel];
    
    _authCodeTF = [[UITextField alloc] init];
    _authCodeTF.textColor = [UIColor whiteColor];
    [self.view addSubview:_authCodeTF];
    
    [_authCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@36);
    }];
    
    [_authCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_authCodeView).offset(10);
        make.centerY.equalTo(_authCodeView);
        make.width.equalTo(@60);
    }];
    
    [_authCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_authCodeLabel.mas_right);
        make.right.equalTo(_authCodeView.mas_right).offset(-10);
        make.centerY.equalTo(_authCodeView);
    }];
    
    _hintLabel = [[UILabel alloc] init];
    _hintLabel.numberOfLines = 0;
    _hintLabel.font = [UIFont systemFontOfSize:15];
    _hintLabel.textColor = [UIColor whiteColor];
    _hintLabel.text = @"安全认证码将发送到您的电子邮箱，如果没有设置邮箱，将无法通过该方法重置密码!";
    [self.view addSubview:_hintLabel];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_authCodeView.mas_bottom).offset(10);
        make.left.right.equalTo(_authCodeView);
    }];
    
    _getAuthCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _getAuthCodeBtn.layer.cornerRadius = 15;
    _getAuthCodeBtn.layer.masksToBounds = YES;
    [_getAuthCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"4EB7CD"]] forState:UIControlStateNormal];
    _getAuthCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_getAuthCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getAuthCodeBtn setTitle:@"获取认证码" forState:UIControlStateNormal];
    [self.view addSubview:_getAuthCodeBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.layer.cornerRadius = 15;
    _confirmBtn.layer.masksToBounds = YES;
    [_confirmBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"22C064"]] forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.view addSubview:_confirmBtn];
    
    [_getAuthCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hintLabel.mas_bottom).offset(20);
        make.left.equalTo(_hintLabel);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hintLabel.mas_bottom).offset(20);
        make.right.equalTo(_hintLabel);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
    _pwd1View = [[UIView alloc] init];
    _pwd1View.layer.borderColor = [UIColor whiteColor].CGColor;
    _pwd1View.layer.borderWidth = 0.5;
    _pwd1View.layer.cornerRadius = 18;
    [self.view addSubview:_pwd1View];
    
    _pwd1Label = [[UILabel alloc] init];
    _pwd1Label.font = [UIFont systemFontOfSize:15];
    _pwd1Label.textColor = [UIColor whiteColor];
    _pwd1Label.text = @"新密码:";
    [self.view addSubview:_pwd1Label];
    
    _pwd1TF = [[UITextField alloc] init];
    _pwd1TF.textColor = [UIColor whiteColor];
    [self.view addSubview:_pwd1TF];
    
    [_pwd1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_getAuthCodeBtn.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@36);
    }];
    
    [_pwd1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pwd1View).offset(10);
        make.centerY.equalTo(_pwd1View);
    }];
    
    [_pwd1TF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pwd1Label.mas_right).offset(10);
        make.right.equalTo(_pwd1View.mas_right).offset(-10);
        make.centerY.equalTo(_pwd1View);
    }];
    
    _pwd2View = [[UIView alloc] init];
    _pwd2View.layer.borderColor = [UIColor whiteColor].CGColor;
    _pwd2View.layer.borderWidth = 0.5;
    _pwd2View.layer.cornerRadius = 18;
    [self.view addSubview:_pwd2View];
    
    _pwd2Label = [[UILabel alloc] init];
    _pwd2Label.font = [UIFont systemFontOfSize:15];
    _pwd2Label.textColor = [UIColor whiteColor];
    _pwd2Label.text = @"新密码:";
    [self.view addSubview:_pwd2Label];
    
    _pwd2TF = [[UITextField alloc] init];
    _pwd2TF.textColor = [UIColor whiteColor];
    [self.view addSubview:_pwd2TF];
    
    [_pwd2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwd1View.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@36);
    }];
    
    [_pwd2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pwd2View).offset(10);
        make.centerY.equalTo(_pwd2View);
    }];
    
    [_pwd2TF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pwd2Label.mas_right).offset(10);
        make.right.equalTo(_pwd2View.mas_right).offset(-10);
        make.centerY.equalTo(_pwd2View);
    }];
    
    _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resetBtn.layer.cornerRadius = 15;
    _resetBtn.layer.masksToBounds = YES;
   [_resetBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"22C064"]] forState:UIControlStateNormal];    _resetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.view addSubview:_resetBtn];
    
    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwd2View.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];



}

@end
