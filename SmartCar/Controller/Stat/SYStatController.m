//
//  SYStatController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYStatController.h"
#import "SYAlarmController.h"
#import "SYGasStatController.h"

@interface SYStatController ()

@property (weak, nonatomic) IBOutlet UIButton *alarmButton;
@property (weak, nonatomic) IBOutlet UIButton *gasButton;
@property (weak, nonatomic) IBOutlet UIButton *oilExceButton;
@property (weak, nonatomic) IBOutlet UIButton *carTravelButton;

@end

@implementation SYStatController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.navigationItem.leftBarButtonItem = nil;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"各类统计";
    self.navigationItem.titleView = titleLabel;
    
}
- (IBAction)statButtonAction:(id)sender {
    NSInteger tag = ((UIButton *)sender).tag;
    if (tag == 201) {
        SYAlarmController *alarmController = [[SYAlarmController alloc] init];
        [self.navigationController pushViewController:alarmController animated:YES];
    } else if (tag == 202) {
        SYGasStatController *gasStatController = [[SYGasStatController alloc] init];
        gasStatController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gasStatController animated:YES];
    
    } else if (tag == 203) {
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
