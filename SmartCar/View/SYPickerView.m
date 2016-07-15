//
//  SYDatePickerView.m
//  SmartCar
//
//  Created by Ezreal on 16/7/13.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYPickerView.h"

@interface SYPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIButton *cancleBtn;
@property(nonatomic, strong) UIButton *confirmBtn;
@property(nonatomic, strong) UIPickerView *pickerView;

@property(nonatomic, strong) NSMutableArray *mutArray;

@property(nonatomic, assign) NSInteger selectRow;

@end

@implementation SYPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    _mutArray = [[NSMutableArray alloc] init];
    [self setupPageSubviews];
    
    return self;
}

- (void)setDataSourceArray:(NSArray *)dataSourceArray {
    [_mutArray removeAllObjects];
    [_mutArray addObjectsFromArray:dataSourceArray];
    [_pickerView reloadAllComponents];
}

- (void)pickClick:(UIButton *)sender {
    if (sender.tag == 100) {
        [self dismiss];
    } else {
        if ([self.delegate respondsToSelector:@selector(pickerView:didSelectAtIndex:)]) {
            [self.delegate pickerView:self didSelectAtIndex:_selectRow];
            [self dismiss];
        }
    }
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

#pragma mark --- 与DataSource有关的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _mutArray.count;
}

#pragma mark --- 与处理有关的代理方法
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 120;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return _mutArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectRow = row;
}

- (void)setupPageSubviews {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0;
    [_bgView addGestureRecognizer:tapGesture];
    [self addSubview:_bgView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottom, self.width, 240)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(10, 0, 60, 40);
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(pickClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancleBtn.tag = 100;
    [_contentView addSubview:_cancleBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(self.width - 70, 0, 60, 40);
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(pickClick:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.tag = 101;
    [_contentView addSubview:_confirmBtn];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_W, 200)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = NO;
    [_contentView addSubview:_pickerView];

}

@end
