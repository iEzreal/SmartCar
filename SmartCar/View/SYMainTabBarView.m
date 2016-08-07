//
//  SYMainTabBarView.m
//  SmartCar
//
//  Created by liuyiming on 16/7/28.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYMainTabBarView.h"

@interface SYMainTabBarView ()

@property(nonatomic, strong) NSMutableArray *itemArray;
@property(nonatomic, strong) UIView *indicatorView;
@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, strong) SYButton *selectBtn;

@end

@implementation SYMainTabBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    NSArray *imageArray = @[@"home_normal", @"static_normal", @"mine_normal"];
    NSArray *titleArray = @[@"首页", @"统计", @"我的"];
    _itemArray = [[NSMutableArray alloc] init];
    
    _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width / 3, self.height)];
    _indicatorView.backgroundColor = TAB_SELECTED_COLOR;
    [self addSubview:_indicatorView];
    
    for (int i = 0; i < 3; i++) {
        SYButton *button = [[SYButton alloc] initWithFrame:CGRectMake( SCREEN_W / 3 * i, 0, SCREEN_W / 3, self.height) image:[UIImage imageNamed:imageArray[i]] title:titleArray[i]];
        
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemCLickAction:) forControlEvents:UIControlEventTouchUpInside];
         button.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentUp;
        button.tag = i;
        [self addSubview:button];
        [_itemArray addObject:button];
        if (i == 0) {
            _selectBtn = button;
            _selectIndex = 0;
        }
    }
    
    return self;
}

- (void)showWithIndex:(NSInteger)index {
    [self itemCLickAction:_itemArray[index]];
}

- (void)itemCLickAction:(SYButton *)sender {
    _selectIndex = sender.tag;
    [UIView animateWithDuration:0.25 animations:^{
        _indicatorView.frame = CGRectMake(self.width / 3 * sender.tag, 0, self.width / 3, self.height);
    } completion:^(BOOL finished) {
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(mainTabBarView:didSelectAtIndex:)]) {
        [self.delegate mainTabBarView:self didSelectAtIndex:sender.tag];
    }
}

@end
