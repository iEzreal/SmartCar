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
@property(nonatomic, strong) UIImageView *moreIV;

@property(nonatomic, strong) UILabel *travelLabel;

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
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.text = @"近期行程";
    [self addSubview:_titleLabel];
    
    _moreIV = [[UIImageView alloc] init];
    _moreIV.image = [UIImage imageNamed:@"check_more_green"];
    [self addSubview:_moreIV];
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    
    _travelLabel = [[UILabel alloc] init];
    _travelLabel.numberOfLines = 0;
    _travelLabel.textColor = [UIColor whiteColor];
    _travelLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_travelLabel];
    
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(5);
        make.width.height.equalTo(@22);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconIV.mas_right).offset(5);
        make.centerY.equalTo(_iconIV);
    }];
    
    [_moreIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(_iconIV);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconIV.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [_travelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.right.equalTo(self).offset(-32);
        make.centerY.equalTo(contentView);
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

    NSString *travelStr = @"";
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            SYTravel *travel = travelArray[i];
            NSString *recvTime = [SYUtil dateWithSateStr:travel.recvTime Format:@"MM月dd日 HH:mm"];
            NSString *mileage = [NSString stringWithFormat:@"%.1f", [travel.OBDTolMileage_E floatValue] / 10];
            NSString *t = [SYUtil intervalFromTime:travel.recvTime toTime:travel.recvTime_E];
            if ([travelStr isEqualToString:@""]) {
                travelStr = [NSString stringWithFormat:@"%@-%@公里,耗时:%@", recvTime, mileage, t];
            } else {
                travelStr = [NSString stringWithFormat:@"%@\n%@-%@公里,耗时:%@", travelStr, recvTime, mileage, t];
            }
        }
    }
    
    _travelLabel.text = travelStr;
}


@end
