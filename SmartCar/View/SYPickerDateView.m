//
//  SYPickerDateView.m
//  SmartCar
//
//  Created by xxx on 16/7/15.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYPickerDateView.h"

#define CONTENT_W (SCREEN_W - 60)
#define CONTENT_H 296
#define YEAR_AMCOUNT 50

@interface SYPickerDateView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIView *BGView;

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *startLabel;
@property(nonatomic, strong) UILabel *endLabel;
@property(nonatomic, strong) UIPickerView *leftPickerView;
@property(nonatomic, strong) UIPickerView *rightPickerView;
@property(nonatomic, strong) UIButton *cancleBtn;
@property(nonatomic, strong) UIButton *confirmBtn;

@property(nonatomic, assign) NSInteger startMonth;
@property(nonatomic, assign) NSInteger startDay;

@property(nonatomic, assign) NSInteger endMonth;
@property(nonatomic, assign) NSInteger endDay;

@end

@implementation SYPickerDateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)])) {
        return nil;
    }
    
    _startMonth = [SYUtil currentMonth];
    _endMonth = _startMonth;
    
    _startDay = [SYUtil currentDay];
    _endDay = _startDay;
    
    [self setupPageSubviews];
    
    return self;
}

- (void)tapGesture:(UITapGestureRecognizer *)sender {
    [self dismiss];
}

#pragma mark - 菜单显示和关闭
- (void)show {
    UIView *superView = [[[UIApplication sharedApplication] windows] firstObject];
    [superView addSubview:self];
    
    _contentView.frame = CGRectMake((SCREEN_W - CONTENT_W) / 2, - CONTENT_H, CONTENT_W, CONTENT_H);
    [UIView animateWithDuration:0.35 animations:^{
        _BGView.alpha = 0.6;
        _contentView.frame = CGRectMake((SCREEN_W - CONTENT_W) / 2, (SCREEN_H - CONTENT_H) / 2, CONTENT_W, CONTENT_H);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.35 animations:^{
        _BGView.alpha = 0;
        _contentView.frame = CGRectMake((SCREEN_W - CONTENT_W) / 2, SCREEN_H + CONTENT_H, CONTENT_W, CONTENT_H);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

#pragma mark - 取消 确定事件
- (void)pickClick:(UIButton *)sender {
    if (sender.tag == 101) {
        if ([self.delegate respondsToSelector:@selector(datePickerView:didSelectStartMonth:startDay:endMonth:endDay:)]) {
            [self.delegate datePickerView:self
                      didSelectStartMonth:_startMonth
                                 startDay:_startDay
                                 endMonth:_endMonth
                                   endDay:_endDay];
        }
    }
    [self dismiss];
}

#pragma mark --- 与DataSource有关的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 1000) {
        if (component == 0) {
            return 12;
        } else {
            return [SYUtil daysOfMonth:_startMonth];
        }
    } else {
        if (component == 0) {
            return 12;
        } else {
            return [SYUtil daysOfMonth:_endMonth];
        }
    }
}

#pragma mark --- 与处理有关的代理方法
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 70;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld月", row + 1];
    } else {
        return [NSString stringWithFormat:@"%ld日", row + 1];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 1000) {
        if (component == 0) {
            _startMonth = row + 1;
            [_leftPickerView reloadComponent:1];
        } else {
            _startDay = row + 1;
        }
        
    } else {
        if (component == 0) {
            _endMonth = row + 1;
            [_rightPickerView reloadComponent:1];

        } else {
            _endDay = row + 1;
        }
    }
}

#pragma mark - 界面UI
- (void)setupPageSubviews {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    _BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _BGView.backgroundColor = [UIColor blackColor];
    _BGView.alpha = 0;
    [_BGView addGestureRecognizer:tapGesture];
    [self addSubview:_BGView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_W - CONTENT_W) / 2, -CONTENT_H, CONTENT_W, CONTENT_H)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
    
    _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CONTENT_W / 2, 40)];
    _startLabel.textAlignment = NSTextAlignmentCenter;
    _startLabel.textColor = [UIColor blackColor];
    _startLabel.text = @"开始日期";
    [_contentView addSubview:_startLabel];
    
    _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_W / 2, 0, CONTENT_W / 2, 40)];
    _endLabel.textAlignment = NSTextAlignmentCenter;
    _endLabel.textColor = [UIColor blackColor];
    _endLabel.text = @"结束日期";
    [_contentView addSubview:_endLabel];
    
    _leftPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CONTENT_W / 2, 216)];
    _leftPickerView.dataSource = self;
    _leftPickerView.delegate = self;
    _leftPickerView.tag = 1000;
    [_contentView addSubview:_leftPickerView];
    
    _rightPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(CONTENT_W / 2, 40, CONTENT_W / 2, 216)];
    _rightPickerView.dataSource = self;
    _rightPickerView.delegate = self;
    _rightPickerView.tag = 1001;
    [_contentView addSubview:_rightPickerView];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(0, 256, CONTENT_W / 2, 40);
    _cancleBtn.backgroundColor = [UIColor colorWithHexString:@"BDC4C8"];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(pickClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancleBtn.tag = 100;
    [_contentView addSubview:_cancleBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(CONTENT_W / 2, 256, CONTENT_W / 2, 40);
    _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"2ADE75"];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(pickClick:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.tag = 101;
    [_contentView addSubview:_confirmBtn];
    
    //
    [_leftPickerView selectRow:_startMonth -1 inComponent:0 animated:NO];
    [_leftPickerView selectRow:_startDay - 1 inComponent:1 animated:NO];
    [_rightPickerView selectRow:_endMonth - 1 inComponent:0 animated:NO];
    [_rightPickerView selectRow:_endDay - 1 inComponent:1 animated:NO];

}


@end
