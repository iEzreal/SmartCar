//
//  SYDatePickerView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/15.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYDatePickerView.h"

@interface SYDatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIButton *cancleBtn;
@property(nonatomic, strong) UIButton *confirmBtn;

@property(nonatomic, strong) UILabel *startLabel;
@property(nonatomic, strong) UILabel *endLabel;
@property(nonatomic, strong) UIPickerView *leftPickerView;
@property(nonatomic, strong) UIPickerView *rightPickerView;

@property(nonatomic, strong) NSMutableArray *yearArray;
@property(nonatomic, strong) NSMutableArray *monthArray;

@property(nonatomic, strong) NSString *startYear;
@property(nonatomic, strong) NSString *startMonth;
@property(nonatomic, assign) NSString *endYear;
@property(nonatomic, strong) NSString *endMonth;



@end

@implementation SYDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    _yearArray = [[NSMutableArray alloc] init];
    _monthArray = [[NSMutableArray alloc] init];
    
    // 50年
    for (int i = 0; i < 50; i++) {
        [_yearArray addObject:[NSString stringWithFormat:@"%d", 2016 - i]];
    }
    
    // 12月
    for (int i = 0; i < 12; i++) {
        [_monthArray addObject:[NSString stringWithFormat:@"%d", i + 1]];
    }
    
    _startYear = _yearArray[0];
    _startMonth = _monthArray[0];
    _endYear = _yearArray[0];
    _endMonth = _monthArray[0];
    
    [self setupPageSubviews];
    
    return self;
}

#pragma mark - 菜单显示和关闭
- (void)showWithView:(UIView *)superView {
    _isShow = true;
    [superView addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        _bgView.alpha = 0.5;
        _contentView.frame = CGRectMake(0, self.bottom - 240, SCREEN_W, 240);
    }];
}

- (void)dismiss {
    _isShow = false;
    [UIView animateWithDuration:0.35 animations:^{
        _bgView.alpha = 0;
        _contentView.frame = CGRectMake(0, self.bottom, SCREEN_W, 240);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)tapGesture:(UITapGestureRecognizer *)sender {
    [self dismiss];
}

#pragma mark - 取消 确定事件
- (void)pickClick:(UIButton *)sender {
    if (sender.tag == 101) {
        if ([self.delegate respondsToSelector:@selector(datePickerView:didSelectStartDate:endDate:)]) {
            [self.delegate datePickerView:self
                       didSelectStartDate:[NSString stringWithFormat:@"%@-%@", _startYear, _startMonth]
                                  endDate:[NSString stringWithFormat:@"%@-%@", _endYear, _endMonth]];
        }
    }
    [self dismiss];
}

#pragma mark --- 与DataSource有关的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _yearArray.count;
    }
    
    return _monthArray.count;
}

#pragma mark --- 与处理有关的代理方法
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 100;
    }
    return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%@年", _yearArray[row]];
    }
    
    return [NSString stringWithFormat:@"%@月", _monthArray[row]];

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 1000) {
        if (component == 0) {
            _startYear = _yearArray[row];
        } else {
            _startMonth = _monthArray[row];
        }
        
    } else {
        if (component == 0) {
            _endYear = _yearArray[row];
        } else {
            _endMonth = _monthArray[row];
        }
    }
}

#pragma mark - 界面UI
- (void)setupPageSubviews {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0;
    [_bgView addGestureRecognizer:tapGesture];
    [self addSubview:_bgView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottom, self.width, 250)];
    _contentView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    [self addSubview:_contentView];
    
    _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2, 30)];
    _startLabel.textAlignment = NSTextAlignmentCenter;
    _startLabel.textColor = [UIColor blackColor];
    _startLabel.text = @"开始日期";
    [_contentView addSubview:_startLabel];
    
    _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W / 2, 0, SCREEN_W / 2, 30)];
    _endLabel.textAlignment = NSTextAlignmentCenter;
    _endLabel.textColor = [UIColor blackColor];
    _endLabel.text = @"结束日期";
    [_contentView addSubview:_endLabel];
    
    _leftPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_W / 2, 180)];
    _leftPickerView.dataSource = self;
    _leftPickerView.delegate = self;
    _leftPickerView.tag = 1000;
    [_contentView addSubview:_leftPickerView];
    
    _rightPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(SCREEN_W / 2, 30, SCREEN_W / 2, 180)];
    _rightPickerView.dataSource = self;
    _rightPickerView.delegate = self;
    _rightPickerView.tag = 1001;
    [_contentView addSubview:_rightPickerView];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(0, 210, self.width / 2, 40);
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(pickClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancleBtn.tag = 100;
    [_contentView addSubview:_cancleBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(self.width / 2, 210, self.width / 2, 40);
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(pickClick:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.tag = 101;
    [_contentView addSubview:_confirmBtn];

}


@end
