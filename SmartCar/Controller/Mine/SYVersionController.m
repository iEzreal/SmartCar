//
//  SYVersionController.m
//  SmartCar
//
//  Created by liuyiming on 16/7/14.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYVersionController.h"

@interface SYVersionController ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *label;

@end

@implementation SYVersionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"版本信息";
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_imageView];
    
    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor whiteColor];
    [self.view addSubview:_label];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.centerX.equalTo(self.view);
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _label.text = app_Version;
    
}

@end
