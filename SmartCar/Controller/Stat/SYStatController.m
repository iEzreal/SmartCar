//
//  SYStatController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYStatController.h"

@interface SYStatController ()

@property (weak, nonatomic) IBOutlet UIButton *alarmButton;
@property (weak, nonatomic) IBOutlet UIButton *gasButton;
@property (weak, nonatomic) IBOutlet UIButton *oilExceButton;
@property (weak, nonatomic) IBOutlet UIButton *carTravelButton;

@end

@implementation SYStatController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    
}
- (IBAction)statButtonAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
