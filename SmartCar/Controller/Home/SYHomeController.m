//
//  SYHomeController.m
//  SmartCar
//
//  Created by liuyiming on 16/6/25.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeController.h"

@interface SYHomeController ()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *view1;

@end

@implementation SYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    _view1.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame), self.view.frame.size.width, 300)];
    view2.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame), self.view.frame.size.width, 300)];
    view3.backgroundColor = [UIColor yellowColor];
    [_scrollView addSubview:view3];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(view3.frame));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
