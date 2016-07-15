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
#import "SYSettingMileageController.h"
#import "SYAboutController.h"
#import "SYVersionController.h"

#import "SYMineHeaderView.h"
#import "SYMineMenuCell.h"

@interface SYMineController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) SYMineHeaderView *headerView;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SYMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.leftBarButtonItem = nil;
    _headerView = [[SYMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 180)];
    _headerView.backgroundColor = [UIColor clearColor];
    
    _headerView.name = [SYAppManager sharedManager].user.userName;
    _headerView.time = [SYAppManager sharedManager].user.loginTime;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = SCREEN_W / 3 * 2;
    if ( h < (SCREEN_H - 64 - 49 - 180) ) {
        h = SCREEN_H - 64 - 49 - 180;
    }
    
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SYMineMenuCell";
    SYMineMenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!menuCell) {
        menuCell = [[SYMineMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        menuCell.backgroundColor = [UIColor colorWithHexString:@"3E4451"];
        menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    menuCell.block = ^(NSInteger index) {
        if (index == 0) {
            SYChangePwdController *pwdController = [[SYChangePwdController alloc] init];
            pwdController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pwdController animated:YES];
            
        } else if (index == 1) {
            SYPersonalInfoController *infoController = [[SYPersonalInfoController alloc] init];
            infoController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoController animated:YES];
        
        } else if (index == 2) {
            SYSettingMileageController *mileageController = [[SYSettingMileageController alloc] init];
            [self.navigationController pushViewController:mileageController animated:YES];
        } else if (index == 3) {
            SYAboutController *aboutController = [[SYAboutController alloc] init];
            aboutController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutController animated:YES];
        } else {
            SYVersionController *versionController = [[SYVersionController alloc] init];
            versionController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:versionController animated:YES];
        }
        
    };
    return menuCell;
}



@end
