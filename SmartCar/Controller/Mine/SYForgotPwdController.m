
//
//  SYForgotPwdController.m
//  SmartCar
//
//  Created by xxx on 16/7/25.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYForgotPwdController.h"

@interface SYForgotPwdController ()

@property(nonatomic, strong) UIView *authCodeView;
@property(nonatomic, strong) UILabel *authCodeLabel;
@property(nonatomic, strong) UITextField *authCodeTF;

@property(nonatomic, strong) UILabel *hintLabel;

@property(nonatomic, strong) UIButton *getAuthCodeBtn;
@property(nonatomic, strong) UIButton *confirmBtn;

@property(nonatomic, strong) UIView *bottomView;
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
/**
 *  发送一个请求，通过邮件获取认证码
 *
 *  @param loginName 登陆名
 */
- (void)sendMailForApprove {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:_loginName forKey:@"userID"];
    [SYUtil showWithStatus:@"正在获取认证码..."];
    [SYApiServer PWD_POST:METHOD_SEND_MAIL_FOR_APPROVE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if ([[responseDic objectForKey:@"SendMailForApproveResult" ] integerValue] == 1) {
            _confirmBtn.enabled = YES;
            NSString *email = [responseDic objectForKey:@"mailAddress"];
            [SYUtil showSuccessWithStatus:[NSString stringWithFormat:@"认证码已发到邮箱:%@", email] duration:3];
            
        } else if ([[responseDic objectForKey:@"SendMailForApproveResult" ] integerValue] == -2){
            NSString *email = [responseDic objectForKey:@"mailAddress"];
            [SYUtil showSuccessWithStatus:[NSString stringWithFormat:@"邮箱%@地址不正确", email] duration:3];
            
        } else if ([[responseDic objectForKey:@"SendMailForApproveResult" ] integerValue] == -1){
            NSString *email = [responseDic objectForKey:@"mailAddress"];
            [SYUtil showSuccessWithStatus:[NSString stringWithFormat:@"发送邮件异常错误:%@", email] duration:3];
            
        } else {
            [SYUtil showErrorWithStatus:@"获取认证码失败" duration:3];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"获取认证码失败" duration:3];
    }];
}

// 邮件认证码验证
- (void)mailForApprove {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:_loginName forKey:@"userID"];
    [parameters setObject:_authCodeTF.text forKey:@"approvecode"];
    [SYApiServer PWD_POST:METHOD_MAIL_FOR_APPROVE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"MailForApproveResult"] integerValue] == 1) {
            _bottomView.hidden = NO;
            DLog(@"----认证码验证通过");
        } else {
            DLog(@"----认证码验证失败");
        }
    } failure:^(NSError *error) {
       DLog(@"----认证码验证失败");
    }];
}

// 重置密码
- (void)approveNewPwd {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:_loginName forKey:@"userID"];
    [parameters setObject:_authCodeTF.text forKey:@"approvecode"];
    [parameters setObject:_pwd1TF.text forKey:@"newPwd"];
    [SYUtil showWithStatus:@"正在重置..."];
    [SYApiServer PWD_POST:METHOD_APPROVE_NEWPWD parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"ApproveNewPwdResult"] integerValue] == 1) {
            [SYUtil showSuccessWithStatus:@"密码重置成功" duration:2];
        } else {
            [SYUtil showErrorWithStatus:@"密码重置失败" duration:2];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"密码重置失败" duration:2];
    }];
}

#pragma mark - 事件处理
- (void)navBackBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)btnClickAction:(UIButton *)sender {
    if (sender.tag == 1001) {
        [self sendMailForApprove];
        
    } else if (sender.tag == 1002) {
        if (![_authCodeTF.text isEqualToString:@""]) {
            [self mailForApprove];
        } else {
            [SYUtil showHintWithStatus:@"请输入认证码" duration:2];
        }
    } else {
        if ([_pwd1TF.text isEqualToString:@""] || [_pwd2TF.text isEqualToString:@""]) {
            [SYUtil showHintWithStatus:@"密码不能为空" duration:2];
            return;
        }
        
        if (![_pwd1TF.text isEqualToString:_pwd2TF.text]) {
            [SYUtil showHintWithStatus:@"两次密码输入不一致" duration:2];
            return;
        }
        
        [self approveNewPwd];
    }
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
    
    _hintLabel = [[UILabel alloc] init];
    _hintLabel.numberOfLines = 0;
    _hintLabel.font = [UIFont systemFontOfSize:15];
    _hintLabel.textColor = [UIColor whiteColor];
    _hintLabel.text = @"安全认证码将发送到您的电子邮箱，如果没有设置邮箱，将无法通过该方法重置密码!";
    [self.view addSubview:_hintLabel];
    
    
    _getAuthCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _getAuthCodeBtn.layer.cornerRadius = 15;
    _getAuthCodeBtn.layer.masksToBounds = YES;
    [_getAuthCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"4EB7CD"]] forState:UIControlStateNormal];
    _getAuthCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_getAuthCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getAuthCodeBtn setTitle:@"获取认证码" forState:UIControlStateNormal];
    [_getAuthCodeBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _getAuthCodeBtn.tag = 1001;
    [self.view addSubview:_getAuthCodeBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.layer.cornerRadius = 15;
    _confirmBtn.layer.masksToBounds = YES;
    [_confirmBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"22C064"]] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"BDC4C8"]] forState:UIControlStateDisabled];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.tag = 1002;
    _confirmBtn.enabled = NO;
    [self.view addSubview:_confirmBtn];
    
    [_authCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_hintLabel.mas_top).offset(-20);
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
    
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_getAuthCodeBtn);
        make.right.equalTo(_confirmBtn);
        make.bottom.equalTo(_getAuthCodeBtn.mas_top).offset(-20);
    }];

    
    [_getAuthCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY).offset(-34);
        make.left.equalTo(self.view).offset(30);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_getAuthCodeBtn);
        make.right.equalTo(self.view).offset(-30);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.hidden = YES;
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).offset(-10);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];

    
    _pwd1View = [[UIView alloc] init];
    _pwd1View.layer.borderColor = [UIColor whiteColor].CGColor;
    _pwd1View.layer.borderWidth = 0.5;
    _pwd1View.layer.cornerRadius = 18;
    [_bottomView addSubview:_pwd1View];
    
    _pwd1Label = [[UILabel alloc] init];
    _pwd1Label.font = [UIFont systemFontOfSize:15];
    _pwd1Label.textColor = [UIColor whiteColor];
    _pwd1Label.text = @"新密码:";
    [_pwd1View addSubview:_pwd1Label];
    
    _pwd1TF = [[UITextField alloc] init];
    _pwd1TF.secureTextEntry = YES;
    _pwd1TF.textColor = [UIColor whiteColor];
    [_pwd1View addSubview:_pwd1TF];
    
    [_pwd1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_bottomView);
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
    [_bottomView addSubview:_pwd2View];
    
    _pwd2Label = [[UILabel alloc] init];
    _pwd2Label.font = [UIFont systemFontOfSize:15];
    _pwd2Label.textColor = [UIColor whiteColor];
    _pwd2Label.text = @"新密码:";
    [_pwd2View addSubview:_pwd2Label];
    
    _pwd2TF = [[UITextField alloc] init];
    _pwd2TF.secureTextEntry = YES;
    _pwd2TF.textColor = [UIColor whiteColor];
    [self.view addSubview:_pwd2TF];
    
    [_pwd2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwd1View.mas_bottom).offset(20);
        make.left.equalTo(_bottomView);
        make.right.equalTo(_bottomView);
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
    [_resetBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _resetBtn.tag = 1003;
    [_bottomView addSubview:_resetBtn];
    
    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwd2View.mas_bottom).offset(20);
        make.bottom.equalTo(_bottomView);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];

}

@end
