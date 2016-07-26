//
//  SYAboutController.m
//  SmartCar
//
//  Created by Ezreal on 16/7/14.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#define SY_URL @"http://www.sycarnet.com"

#import "SYAboutController.h"

@interface SYAboutController ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UILabel *label1;
@property(nonatomic, strong) UILabel *label2;
@property(nonatomic, strong) UILabel *label3;
@property(nonatomic, strong) UILabel *label4;
@property(nonatomic, strong) UIButton *urlBtn;

@end

@implementation SYAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"logo_sy"];
    [self.view addSubview:_imageView];
    
    _label1 = [[UILabel alloc] init];
    _label1.font = [UIFont systemFontOfSize:18];
    _label1.textColor = [UIColor whiteColor];
    _label1.text = @"上海圣禹电子科技有限公司";
    [self.view addSubview:_label1];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_lineView];
    
    _label2 = [[UILabel alloc] init];
    _label2.font = [UIFont systemFontOfSize:18];
    _label2.textColor = [UIColor whiteColor];
    _label2.text = @"车联网客户端";
    [self.view addSubview:_label2];
    
    _label3 = [[UILabel alloc] init];
    _label3.font = [UIFont systemFontOfSize:18];
    _label3.textColor = [UIColor whiteColor];
    _label3.text = @"我们专做车联网，所以专业。";
    [self.view addSubview:_label3];
    
    _label4 = [[UILabel alloc] init];
    _label4.font = [UIFont systemFontOfSize:18];
    _label4.textColor = [UIColor whiteColor];
    _label4.text = @"公司网址:";
    [self.view addSubview:_label4];
    
    _urlBtn = [[UIButton alloc] init];
    _urlBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_urlBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_urlBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_urlBtn setTitle:SY_URL forState:UIControlStateNormal];
    [_urlBtn addTarget:self action:@selector(returnToBrowser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_urlBtn];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.centerX.equalTo(self.view);
    }];
    
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label1.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@0.5);
    }];
    
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
    }];
    
    [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label2.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
    }];
    
    [_label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label3.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
    }];
    
    [_urlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label4.mas_right).offset(10);
        make.centerY.equalTo(_label4);
    }];
    
}

- (void)returnToBrowser:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SY_URL]];
}


@end
