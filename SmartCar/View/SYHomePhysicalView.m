//
//  SYHomePhysicalView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomePhysicalView.h"
#import "SYHomeMoreView.h"

@interface SYHomePhysicalView ()

@property(nonatomic, strong) UIButton *eventBtn;
@property(nonatomic, strong) SYHomeMoreView *moreView;
@property(nonatomic, strong) UILabel *physicalLabel;

@end

@implementation SYHomePhysicalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _eventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _eventBtn.frame = CGRectMake(0, 0, self.width, self.height);
    [_eventBtn setBackgroundImage:[UIImage imageWithColor:PAGE_BG_COLOR] forState:UIControlStateNormal];
    [_eventBtn setBackgroundImage:[UIImage imageWithColor:TAB_SELECTED_COLOR] forState:UIControlStateHighlighted];
    [_eventBtn addTarget:self action:@selector(clickEventAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_eventBtn];
    
    _moreView = [[SYHomeMoreView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
    _moreView.title = @"车辆体检";
    _moreView.image = [UIImage imageNamed:@"icon_physical"];
    _moreView.moreBGColor = [UIColor colorWithHexString:@"2ADE75"];
    [self addSubview:_moreView];
    
    _physicalLabel = [[UILabel alloc] init];
    _physicalLabel.textAlignment = NSTextAlignmentCenter;
    _physicalLabel.numberOfLines = 0;
    _physicalLabel.textColor = [UIColor whiteColor];
    _physicalLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_physicalLabel];
    [_physicalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moreView.mas_bottom);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-5);
    }];

    return self;
}

- (void)clickEventAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(morePhysicalAction)]) {
        [self.delegate morePhysicalAction];
    }
}

@end
