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

@property(nonatomic, strong) UILabel *travelLabel;

@end

@implementation SYHomeTravelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    _moreView = [[SYHomeMoreView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    _moreView.title = @"近期行程";
    _moreView.image = [UIImage imageNamed:@"icon_travel"];
    _moreView.delegate = self;
    [self addSubview:_moreView];
    
    _travelLabel = [[UILabel alloc] init];
    _travelLabel.textAlignment = NSTextAlignmentCenter;
    _travelLabel.numberOfLines = 0;
    _travelLabel.textColor = [UIColor whiteColor];
    _travelLabel.font = [UIFont systemFontOfSize:15];
    _travelLabel.text = @"最近十天内无行程记录，请查看更多行程信息";
    [self addSubview:_travelLabel];
    [_travelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    _travelLabel.text = travelStr;
}


@end
