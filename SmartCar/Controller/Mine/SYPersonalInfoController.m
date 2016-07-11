//
//  SYPersonalInfoController.m
//  SmartCar
//
//  Created by liuyiming on 16/7/9.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYPersonalInfoController.h"

@interface SYPersonalInfoController ()

@property(nonatomic, strong) UIImageView *infoLogo;

@property(nonatomic, strong) UIView *userNameView;
@property(nonatomic, strong) UIImageView *userNameIV;
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UITextField *userNameTF;

@property(nonatomic, strong) UIView *phoneView;
@property(nonatomic, strong) UIImageView *phoneIV;
@property(nonatomic, strong) UILabel *phoneLabel;
@property(nonatomic, strong) UITextField *phoneTF;

@property(nonatomic, strong) UIView *compView;
@property(nonatomic, strong) UIImageView *compIV;
@property(nonatomic, strong) UILabel *compLabel;
@property(nonatomic, strong) UITextField *compTF;

@property(nonatomic, strong) UIView *emailView;
@property(nonatomic, strong) UIImageView *emailIV;
@property(nonatomic, strong) UILabel *emailLabel;
@property(nonatomic, strong) UITextField *emailTF;

@property(nonatomic, strong) UIView *addressView;
@property(nonatomic, strong) UIImageView *addressIV;
@property(nonatomic, strong) UILabel *addressLabel;
@property(nonatomic, strong) UITextField *addressTF;

@property(nonatomic, strong) UIButton *saveBtn;
@property(nonatomic, strong) UIButton *resetBtn;

@end

@implementation SYPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    
    [self setupPageSubviews];
    [self layoutPageSubviews];
    
    [self refreshUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshUserInfo {
    _userNameTF.text = [SYAppManager sharedManager].user.userName;
    _phoneTF.text = [SYAppManager sharedManager].user.phone1;
    _compTF.text = [SYAppManager sharedManager].user.company;
    _emailTF.text = [SYAppManager sharedManager].user.email;
    _addressTF.text = [SYAppManager sharedManager].user.address;
}

- (void)changePersonalInfoAction:(UIButton *)sender {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[SYAppManager sharedManager].user.loginName forKey:@"UserId"];
    [parameters setObject:_userNameTF.text forKey:@"username "];
    [parameters setObject:_phoneTF.text forKey:@"phone"];
    [parameters setObject:_emailTF.text forKey:@"email"];
    [parameters setObject:_compTF.text forKey:@"comp"];
    [parameters setObject:_addressTF.text forKey:@"addr"];
    
    [SVProgressHUD showWithStatus:@"正在提交..."];
    [SYApiServer POST:METHOD_USER_INFO_UPDATE parameters:parameters success:^(id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseStr objectFromJSONString];
        if ([[responseDic objectForKey:@"UserInfoUpdateResult"] integerValue] == 1) {
            [SYAppManager sharedManager].user.userName = _userNameTF.text;
            [SYAppManager sharedManager].user.phone1 = _phoneTF.text;
            [SYAppManager sharedManager].user.email = _emailTF.text;
            [SYAppManager sharedManager].user.company = _compTF.text;
            [SYAppManager sharedManager].user.address = _addressTF.text;
            [self refreshUserInfo];
            [SVProgressHUD showSuccessWithStatus:@"个人信息修改成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"个人信息修改失败"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"个人信息修改失败"];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)setupPageSubviews {
    _infoLogo = [[UIImageView alloc] init];
    _infoLogo.image = [UIImage imageNamed:@"mine_info"];
    [self.view addSubview:_infoLogo];
    
    // 用户名
    _userNameView = [[UIView alloc] init];
    _userNameView.layer.borderColor = [UIColor whiteColor].CGColor;
    _userNameView.layer.borderWidth = 0.5;
    _userNameView.layer.cornerRadius = 18;
    [self.view addSubview:_userNameView];
    
    _userNameIV = [[UIImageView alloc] init];
    _userNameIV.image = [UIImage imageNamed:@"login_name_icon"];
    [self.view addSubview:_userNameIV];
    
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.font = [UIFont systemFontOfSize:15];
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.text = @"用户名:";
    [self.view addSubview:_userNameLabel];
    
    _userNameTF = [[UITextField alloc] init];
    _userNameTF.textColor = [UIColor whiteColor];
    _userNameTF.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_userNameTF];
    
    // 手机
    _phoneView = [[UIView alloc] init];
    _phoneView.layer.borderColor = [UIColor whiteColor].CGColor;
    _phoneView.layer.borderWidth = 0.5;
    _phoneView.layer.cornerRadius = 18;
    [self.view addSubview:_phoneView];
    
    _phoneIV = [[UIImageView alloc] init];
    _phoneIV.image = [UIImage imageNamed:@"info_icon_mobile"];
    [self.view addSubview:_phoneIV];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.text = @"手机:";
    [self.view addSubview:_phoneLabel];
    
    _phoneTF = [[UITextField alloc] init];
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.textColor = [UIColor whiteColor];
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_phoneTF];
    
    // 公司
    _compView = [[UIView alloc] init];
    _compView.layer.borderColor = [UIColor whiteColor].CGColor;
    _compView.layer.borderWidth = 0.5;
    _compView.layer.cornerRadius = 18;
    [self.view addSubview:_compView];
    
    _compIV = [[UIImageView alloc] init];
    _compIV.image = [UIImage imageNamed:@"info_icon_cpy"];
    [self.view addSubview:_compIV];
    
    _compLabel = [[UILabel alloc] init];
    _compLabel.font = [UIFont systemFontOfSize:15];
    _compLabel.textColor = [UIColor whiteColor];
    _compLabel.text = @"公司:";
    [self.view addSubview:_compLabel];
    
    _compTF = [[UITextField alloc] init];
    _compTF.textColor = [UIColor whiteColor];
    _compTF.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_compTF];
    
    // email
    _emailView = [[UIView alloc] init];
    _emailView.layer.borderColor = [UIColor whiteColor].CGColor;
    _emailView.layer.borderWidth = 0.5;
    _emailView.layer.cornerRadius = 18;
    [self.view addSubview:_emailView];
    
    _emailIV = [[UIImageView alloc] init];
    _emailIV.image = [UIImage imageNamed:@"info_icon_email"];
    [self.view addSubview:_emailIV];
    
    _emailLabel = [[UILabel alloc] init];
    _emailLabel.font = [UIFont systemFontOfSize:15];
    _emailLabel.textColor = [UIColor whiteColor];
    _emailLabel.text = @"Email:";
    [self.view addSubview:_emailLabel];
    
    _emailTF = [[UITextField alloc] init];
    _emailTF.keyboardType = UIKeyboardTypeEmailAddress;
    _emailTF.textColor = [UIColor whiteColor];
    _emailTF.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_emailTF];

    // 地址
    _addressView = [[UIView alloc] init];
    _addressView.layer.borderColor = [UIColor whiteColor].CGColor;
    _addressView.layer.borderWidth = 0.5;
    _addressView.layer.cornerRadius = 18;
    [self.view addSubview:_addressView];
    
    _addressIV = [[UIImageView alloc] init];
    _addressIV.image = [UIImage imageNamed:@"info_icon_addr"];
    [self.view addSubview:_addressIV];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.font = [UIFont systemFontOfSize:15];
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.text = @"地址:";
    [self.view addSubview:_addressLabel];
    
    _addressTF = [[UITextField alloc] init];
    _addressTF.font = [UIFont systemFontOfSize:15];
    _addressTF.textColor = [UIColor whiteColor];
    [self.view addSubview:_addressTF];
    
    //
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_save_n"] forState:UIControlStateNormal];
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_save_h"] forState:UIControlStateHighlighted];
    [_saveBtn addTarget:self action:@selector(changePersonalInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    
    _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_reset_n"] forState:UIControlStateNormal];
    [_resetBtn setBackgroundImage:[UIImage imageNamed:@"btn_reset_h"] forState:UIControlStateHighlighted];
    [_resetBtn addTarget:self action:@selector(changePersonalInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetBtn];

}

- (void)layoutPageSubviews {
    [_infoLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    [_userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoLogo.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@36);
    }];
    
    [_userNameIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameView).offset(10);
        make.centerY.equalTo(_userNameView);
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameIV.mas_right).offset(5);
        make.centerY.equalTo(_userNameView);
    }];
    
    [_userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLabel.mas_right).offset(6);
        make.right.equalTo(_userNameView.mas_right).offset(-6);
        make.centerY.equalTo(_userNameView);
    }];
    
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@36);
    }];
    
    [_phoneIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneView).offset(10);
        make.centerY.equalTo(_phoneView);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneIV.mas_right).offset(5);
        make.centerY.equalTo(_phoneView);
    }];
    
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneLabel.mas_right).offset(6);
        make.right.equalTo(_phoneView.mas_right).offset(-6);
        make.centerY.equalTo(_phoneView);
    }];
    
    [_compView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneView.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@36);
    }];
    
    [_compIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_compView).offset(10);
        make.centerY.equalTo(_compView);
    }];
    
    [_compLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_compIV.mas_right).offset(5);
        make.centerY.equalTo(_compView);
    }];
    
    [_compTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_compLabel.mas_right).offset(6);
        make.right.equalTo(_compView.mas_right).offset(-6);
        make.centerY.equalTo(_compView);
    }];
    
    [_emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_compView.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@36);
    }];
    
    [_emailIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_emailView).offset(10);
        make.centerY.equalTo(_emailView);
    }];
    
    [_emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_emailIV.mas_right).offset(5);
        make.centerY.equalTo(_emailView);
    }];
    
    [_emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_emailLabel.mas_right).offset(6);
        make.right.equalTo(_emailView.mas_right).offset(-6);
        make.centerY.equalTo(_emailView);
    }];
    
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_emailView.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@36);
    }];
    
    [_addressIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressView).offset(10);
        make.centerY.equalTo(_addressView);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressIV.mas_right).offset(5);
        make.centerY.equalTo(_addressView);
    }];
    
    [_addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressLabel.mas_right).offset(6);
        make.right.equalTo(_addressView.mas_right).offset(6);
        make.centerY.equalTo(_addressView);
    }];
    
    //
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressView.mas_bottom).offset(30);
        make.left.equalTo(_addressView);
    }];
    
    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveBtn);
        make.right.equalTo(_addressView);
    }];
}


@end