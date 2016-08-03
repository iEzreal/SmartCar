//
//  SYHomeTravelView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/18.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeTravelView.h"
#import "SYTravel.h"

@interface SYHomeTravelView ()

@property(nonatomic, strong) UIButton *eventBtn;

@property(nonatomic, strong) UIImageView *iconIV;
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UILabel *travel1Label;
@property(nonatomic, strong) UILabel *travel2Label;

@property(nonatomic, strong) UIImageView *moreIV;

@end

@implementation SYHomeTravelView

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
    
    _iconIV = [[UIImageView alloc] init];
    _iconIV.image = [UIImage imageNamed:@"icon_travel"];
    [self addSubview:_iconIV];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.text = @"近期\n行程";
    [self addSubview:_titleLabel];
    
    _moreIV = [[UIImageView alloc] init];
    _moreIV.image = [UIImage imageNamed:@"check_more_green"];
    [self addSubview:_moreIV];
    
    _travel1Label = [[UILabel alloc] init];
    _travel1Label.textColor = [UIColor whiteColor];
    _travel1Label.font = [UIFont systemFontOfSize:16];
    [self addSubview:_travel1Label];
    
    _travel2Label = [[UILabel alloc] init];
    _travel2Label.textColor = [UIColor whiteColor];
    _travel2Label.font = [UIFont systemFontOfSize:16];
    [self addSubview:_travel2Label];
    
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.width.height.equalTo(@33);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(_iconIV.mas_right).offset(5);
        make.centerY.equalTo(_iconIV);
        make.width.equalTo(@32);
    }];
    
    [_travel1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(_titleLabel.mas_right).offset(10);
        make.right.equalTo(_moreIV.mas_left).offset(-10);
    }];
    
    [_travel2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_travel1Label.mas_bottom).offset(4);
        make.left.equalTo(_travel1Label);
        make.right.equalTo(_travel1Label);
    }];
    
    [_moreIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(_iconIV);
        make.width.equalTo(@50);
    }];


    
    return self;
}

- (void)clickEventAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(moreTraveAction)]) {
        [self.delegate moreTraveAction];
    }
}

- (void)setTravelArray:(NSMutableArray *)travelArray {
    NSInteger count = travelArray.count;
    if (count > 2) {
        count = 2;
    }

    for (int i = 0; i < count; i++) {
         NSString *travelStr = @"";
        @autoreleasepool {
            SYTravel *travel = travelArray[i];
            NSString *recvTime = [SYUtil dateWithSateStr:travel.recvTime Format:@"MM月dd日 HH:mm"];
            NSString *mileage = [NSString stringWithFormat:@"%.1f", [travel.OBDTolMileage_E floatValue] / 10];
            NSString *t = [SYUtil intervalFromTime:travel.recvTime toTime:travel.recvTime_E];
            travelStr = [NSString stringWithFormat:@"%@-%@公里,耗时:%@", recvTime, mileage, t];
        }
        if (i == 0) {
             _travel1Label.text = travelStr;
        } else {
             _travel2Label.text = travelStr;
        }
    }
}


@end
