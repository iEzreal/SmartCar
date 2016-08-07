//
//  SYPickerAlertView.m
//  SmartCar
//
//  Created by liuyiming on 16/6/29.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYPickerAlertView.h"

#define CONTENT_W (SCREEN_W - 60)
#define CONTENT_H 296

@interface SYPickerAlertView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIView *BGView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIButton *cancleBtn;
@property(nonatomic, strong) UIButton *confirmBtn;

@property(nonatomic, assign) NSInteger curSelectedRow;

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation SYPickerAlertView

- (instancetype)initWithTitle:(NSString *)title dataArray:(NSArray *)dataArray {
    if (!(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)])) {
        return nil;
    }
    _title = title;
    _dataArray = dataArray;
    
    [self setupPageSubviews];
    
    return self;
}

#pragma mark - 点击事件
- (void)pickBtnClick:(UIButton *)sender {
    if (sender.tag == 101) {
        if ([self.delegate respondsToSelector:@selector(pickerAlertView:didSelectAtIndex:)]) {
            [self.delegate pickerAlertView:self didSelectAtIndex:_curSelectedRow];
            [self dismiss];
        }
    } else {
        [self dismiss];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)sender {
    [self dismiss];
}

#pragma mark - 菜单显示和关闭
- (void)show {
    UIView *superView = [[[UIApplication sharedApplication] windows] firstObject];
    [superView addSubview:self];
    
    _BGView.alpha = 0.6;
    _contentView.frame = CGRectMake((SCREEN_W - CONTENT_W) / 2, (SCREEN_H - CONTENT_H) / 2, CONTENT_W, CONTENT_H);
}

- (void)dismiss {
    _BGView.alpha = 0;
    [self removeFromSuperview];
}

#pragma mark --- 与DataSource有关的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataArray.count;
}

#pragma mark --- 与处理有关的代理方法
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return CONTENT_W;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return _dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _curSelectedRow = row;
}

#pragma mark - 界面UI
- (void)setupPageSubviews {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    _BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _BGView.backgroundColor = [UIColor blackColor];
    _BGView.alpha = 0;
    [_BGView addGestureRecognizer:tapGesture];
    [self addSubview:_BGView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_W - CONTENT_W) / 2, (SCREEN_H - CONTENT_H) / 2, CONTENT_W, CONTENT_H)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor colorWithHexString:PAGE_TOP_COLOR];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = _title;
    [_contentView addSubview:_titleLabel];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CONTENT_W, 216)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = NO;
    [_contentView addSubview:_pickerView];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(0, 256, CONTENT_W / 2, 40);
    _cancleBtn.backgroundColor = [UIColor colorWithHexString:@"BDC4C8"];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(pickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancleBtn.tag = 100;
    [_contentView addSubview:_cancleBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(CONTENT_W / 2, 256, CONTENT_W / 2, 40);
    _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"2ADE75"];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(pickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.tag = 101;
    [_contentView addSubview:_confirmBtn];
}


@end
