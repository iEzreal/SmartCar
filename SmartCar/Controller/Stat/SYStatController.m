//
//  SYStatController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYStatController.h"
#import "SYAlarmStatController.h"
#import "SYGasStatController.h"
#import "SYOilExceptionController.h"
#import "SYTravelIInfoController.h"

@interface SYStatController ()

@property (weak, nonatomic) IBOutlet UIButton *alarmButton;
@property (weak, nonatomic) IBOutlet UIButton *gasButton;
@property (weak, nonatomic) IBOutlet UIButton *oilExceButton;
@property (weak, nonatomic) IBOutlet UIButton *carTravelButton;

@end

@implementation SYStatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)statButtonAction:(id)sender {
    NSInteger tag = ((UIButton *)sender).tag;
    if (tag == 201) {
        SYAlarmStatController *alarmController = [[SYAlarmStatController alloc] init];
        [self.navigationController pushViewController:alarmController animated:YES];
        
    } else if (tag == 202) {
        SYGasStatController *gasStatController = [[SYGasStatController alloc] init];
        [self.navigationController pushViewController:gasStatController animated:YES];
    
    } else if (tag == 203) {
        SYOilExceptionController *exceptionController = [[SYOilExceptionController alloc] init];
        [self.navigationController pushViewController:exceptionController animated:YES];

    } else {
        SYTravelIInfoController *travelController = [[SYTravelIInfoController alloc] init];
        [self.navigationController pushViewController:travelController animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
