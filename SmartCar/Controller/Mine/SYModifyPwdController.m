//
//  SYModifyPwdController.m
//  SmartCar
//
//  Created by liuyiming on 16/7/9.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYModifyPwdController.h"

@interface SYModifyPwdController ()

@property(nonatomic, strong) UIImageView *pwdLogo;

@property(nonatomic, strong) UILabel *oldPwdLabel;
@property(nonatomic, strong) UITextField *oldPwdTF;

@property(nonatomic, strong) UILabel *nwePwd1Label;
@property(nonatomic, strong) UITextField *nwePwd1TF;

@property(nonatomic, strong) UILabel *nwePwd2Label;
@property(nonatomic, strong) UITextField *nwePwd2TF;

@property(nonatomic, strong) UIButton *saveBtn;
@property(nonatomic, strong) UIButton *resetBtn;

@end

@implementation SYModifyPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    
    _pwdLogo = [[UIImageView alloc] init];
    _pwdLogo.image = [UIImage imageNamed:@"mine_pwd_icon"];
    [self.view addSubview:_pwdLogo];
    [_pwdLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    // 旧密码
    UIView *oldPwdView = [[UIView alloc] init];
    oldPwdView.layer.borderColor = [UIColor whiteColor].CGColor;
    oldPwdView.layer.borderWidth = 0.5;
    oldPwdView.layer.cornerRadius = 18;
    [self.view addSubview:oldPwdView];
    
    _oldPwdLabel = [[UILabel alloc] init];
    _oldPwdLabel.font = [UIFont systemFontOfSize:15];
    _oldPwdLabel.textColor = [UIColor whiteColor];
    _oldPwdLabel.text = @"旧密码:";
    [self.view addSubview:_oldPwdLabel];
    
    _oldPwdTF = [[UITextField alloc] init];
    _oldPwdTF.textColor = [UIColor whiteColor];
    [self.view addSubview:_oldPwdTF];
    
    [oldPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwdLogo.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@36);
    }];
    
    [_oldPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldPwdView).offset(10);
        make.centerY.equalTo(oldPwdView);
    }];
    
    [_oldPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_oldPwdLabel.mas_right).offset(10);
        make.right.equalTo(oldPwdView.mas_right).offset(-10);
        make.centerY.equalTo(oldPwdView);
    }];
    
    // 新密码1
    UIView *nwe1PwdView = [[UIView alloc] init];
    nwe1PwdView.layer.borderColor = [UIColor whiteColor].CGColor;
    nwe1PwdView.layer.borderWidth = 0.5;
    nwe1PwdView.layer.cornerRadius = 18;
    [self.view addSubview:nwe1PwdView];
    
    _nwePwd1Label = [[UILabel alloc] init];
    _nwePwd1Label.font = [UIFont systemFontOfSize:15];
    _nwePwd1Label.textColor = [UIColor whiteColor];
    _nwePwd1Label.text = @"新密码:";
    [self.view addSubview:_nwePwd1Label];
    
    _nwePwd1TF = [[UITextField alloc] init];
    _nwePwd1TF.textColor = [UIColor whiteColor];
    [self.view addSubview:_nwePwd1TF];
    
    [nwe1PwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldPwdView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@36);
    }];
    
    [_nwePwd1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nwe1PwdView).offset(10);
        make.centerY.equalTo(nwe1PwdView);
    }];
    
    [_nwePwd1TF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nwePwd1Label.mas_right).offset(10);
        make.right.equalTo(nwe1PwdView.mas_right).offset(-10);
        make.centerY.equalTo(nwe1PwdView);
    }];
    
    // 新密码2
    UIView *nwe2PwdView = [[UIView alloc] init];
    nwe2PwdView.layer.borderColor = [UIColor whiteColor].CGColor;
    nwe2PwdView.layer.borderWidth = 0.5;
    nwe2PwdView.layer.cornerRadius = 18;
    [self.view addSubview:nwe2PwdView];
    
    _nwePwd2Label = [[UILabel alloc] init];
    _nwePwd2Label.font = [UIFont systemFontOfSize:15];
    _nwePwd2Label.textColor = [UIColor whiteColor];
    _nwePwd2Label.text = @"新密码:";
    [self.view addSubview:_nwePwd2Label];
    
    _nwePwd2TF = [[UITextField alloc] init];
    _nwePwd2TF.textColor = [UIColor whiteColor];
    [self.view addSubview:_nwePwd2TF];
    
    [nwe2PwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nwe1PwdView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@36);
    }];
    
    [_nwePwd2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nwe2PwdView).offset(10);
        make.centerY.equalTo(nwe2PwdView);
    }];
    
    [_nwePwd2TF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nwePwd2Label.mas_right).offset(10);
        make.right.equalTo(nwe2PwdView.mas_right).offset(-10);
        make.centerY.equalTo(nwe2PwdView);
    }];

    //
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_save_n"] forState:UIControlStateNormal];
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_save_h"] forState:UIControlStateHighlighted];
    [_saveBtn addTarget:self action:@selector(changePwdAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    
    _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_reset_n"] forState:UIControlStateNormal];
    [_resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_reset_h"] forState:UIControlStateHighlighted];
    [_resetBtn addTarget:self action:@selector(changePwdAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_resetBtn];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nwe2PwdView.mas_bottom).offset(30);
        make.left.equalTo(nwe2PwdView);
    }];
    
    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveBtn);
        make.right.equalTo(nwe2PwdView);
    }];
}

- (void)changePwdAction:(UIButton *)sender {
    if ([_oldPwdTF.text isEqualToString:@""]) {
        [SYUtil showHintWithStatus:@"请输入原密码" duration:1];
        return;
    }
    
    if (![_oldPwdTF.text isEqualToString:[SYAppManager sharedManager].user.password]) {
        [SYUtil showHintWithStatus:@"原密码不正确" duration:1];
        return;
    }

    
    if ([_nwePwd1TF.text isEqualToString:@""]) {
        [SYUtil showHintWithStatus:@"请输入新密码" duration:1];
        return;
    }
    
    if ([_nwePwd2TF.text isEqualToString:@""]) {
        [SYUtil showHintWithStatus:@"请再次输入新密码" duration:1];
        return;
    }
    
    if (![_nwePwd1TF.text isEqualToString:_nwePwd2TF.text]) {
        [SYUtil showHintWithStatus:@"两次输入密码不一致" duration:1];
        return;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[SYAppManager sharedManager].user.loginName forKey:@"UserId"];
    [parameters setObject:_nwePwd1TF.text forKey:@"password"];

    [SYUtil showWithStatus:@"正在提交..."];
    [SYApiServer POST:METHOD_CHANGE_PASSWORD parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if (responseDic && [[responseDic objectForKey:@"ChangePasswordResult"] integerValue] == 1) {
            [SYUtil showSuccessWithStatus:@"密码修改成功" duration:1];
        } else {
            [SYUtil showErrorWithStatus:@"密码修改失败" duration:2];
        }
    } failure:^(NSError *error) {
        [SYUtil showErrorWithStatus:@"密码修改失败" duration:2];
    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
