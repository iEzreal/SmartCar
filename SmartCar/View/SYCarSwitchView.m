//
//  SYCarSwitchView.m
//  SmartCar
//
//  Created by xxx on 16/6/29.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYCarSwitchView.h"

#define CONTENT_H 200

@interface SYCarSwitchView () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UIView *BGView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *sourceArray;

@end

@implementation SYCarSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return self;
    }
    
    _sourceArray = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    _BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _BGView.backgroundColor = [UIColor blackColor];
    _BGView.alpha = 0.0;
    [_BGView addGestureRecognizer:tapGesture];
    [self addSubview:_BGView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, -CONTENT_H, self.width, CONTENT_H)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, CONTENT_H) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_contentView addSubview:_tableView];
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SYCarSwitchViewCell";
    SYCarSwitchViewCell  *carSwitchCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!carSwitchCell) {
        carSwitchCell = [[SYCarSwitchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        carSwitchCell.backgroundColor = [UIColor colorWithHexString:HOME_BG_COLOR];
    }
    
    carSwitchCell.contentLabel.text = _sourceArray[indexPath.row];
    
    return carSwitchCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(carSwitchView:didSelectRowAtIndex:)]) {
        [self.delegate carSwitchView:self didSelectRowAtIndex:indexPath.row];
    }
    
    [self hide];
}


- (void)setSRCArray:(NSArray *)sourceArray {
    [_sourceArray removeAllObjects];
    [_sourceArray addObjectsFromArray:sourceArray];
    [_tableView reloadData];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    [self hide];
}

- (void)showWithView:(UIView *)superView {
    _show = YES;
    [superView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        _BGView.alpha = 0.5;
        _contentView.frame = CGRectMake(0,  0, self.width,  CONTENT_H);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    _show = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _BGView.alpha = 0.0;
        _contentView.frame = CGRectMake(0,  -CONTENT_H, self.width, CONTENT_H);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

/******************************************************************************/
/*                          SYCarSwitchViewCell                               */
/******************************************************************************/
@interface SYCarSwitchViewCell ()

@end

@implementation SYCarSwitchViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_contentLabel];
    
    return self;
}


@end
