//
//  SYHomeTravelView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/18.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYHomeTravelView.h"
#import "SYHomeMoreView.h"
#import "SYTravel.h"

@interface SYHomeTravelView () <SYHomeMoreViewDelegate>

@property(nonatomic, strong) SYHomeMoreView *moreView;

@property(nonatomic, strong) UILabel *travelLabel1;
@property(nonatomic, strong) UILabel *travelLabel2;
@property(nonatomic, strong) UILabel *travelLabel3;
@property(nonatomic, strong) UILabel *travelLabel4;

@end

@implementation SYHomeTravelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    _moreView = [[SYHomeMoreView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    _moreView.delegate = self;
    [self addSubview:_moreView];
    
    _travelLabel1 = [[UILabel alloc] init];
    _travelLabel1.textAlignment = NSTextAlignmentCenter;
    _travelLabel1.numberOfLines = 0;
    _travelLabel1.textColor = [UIColor whiteColor];
    _travelLabel1.font = [UIFont systemFontOfSize:15];
    [self addSubview:_travelLabel1];
    [_travelLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moreView.mas_bottom);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    
    return self;
}

- (void)moreAction {
    if ([self.delegate respondsToSelector:@selector(moreTraveAction)]) {
        [self.delegate moreTraveAction];
    }
}

- (void)setTravelArray:(NSMutableArray *)travelArray {
    NSInteger count = travelArray.count;
    if (count > 5) {
        count = 5;
    }

    NSString *travelStr = @"";
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            SYTravel *travel = travelArray[i];
            NSString *t = [SYUtil intervalFromTime:travel.recvTime toTime:travel.recvTime_E];
            if ([travelStr isEqualToString:@""]) {
                travelStr = [NSString stringWithFormat:@"%@—%.1f公里—耗时%@", travel.recvTime, [travel.OBDTolMileage_E floatValue] /10, t];
            } else {
                travelStr = [NSString stringWithFormat:@"%@\n%@—%.1f公里—耗时%@", travelStr, travel.recvTime, [travel.OBDTolMileage_E floatValue] /10, t];
            }
        }
    }
    
    _travelLabel1.text = travelStr;
}


@end
