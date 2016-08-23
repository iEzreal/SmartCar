//
//  SYMineMenuView.m
//  SmartCar
//
//  Created by xxx on 16/7/23.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYMineMenuView.h"

@implementation SYMineMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    NSArray *imageArray = @[@"mine_upwd", @"mine_personal", @"mine_milestage",
                            @"mine_car_physical", @"mine_afterservice ", @"mine_softupdate"];
    NSArray *titleArray = @[@"修改密码", @"个人信息", @"初始里程",
                            @"车辆体检", @"关于我们", @"版本信息"];
    // 总共5个 分3列
    for (int i = 0; i < 6; i++) {
        long rowIndex = i / 3;
        long columnIndex = i % 3;
        
        CGFloat w =  (SCREEN_W - 40) / 3;
        CGFloat h = w;
        CGFloat x = w * columnIndex;
        CGFloat y = h * rowIndex;
        
        SYButton *menuItem = [[SYButton alloc] initWithFrame:CGRectMake(x, y, w, h) image:[UIImage imageNamed:imageArray[i]] title:titleArray[i]];
        menuItem.imgTextDistance = 10;
        menuItem.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentUp;
        menuItem.backgroundColor = [UIColor clearColor];
        [menuItem setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e5e5e5"]] forState:UIControlStateHighlighted];
        [menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        menuItem.tag = i;
        [menuItem addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuItem];
    }

    return self;
}

- (void)itemClickAction:(UIButton *)sender {
    if ([self.deleagate respondsToSelector:@selector(menuView:didSelectedAtIndex:)]) {
        [self.deleagate menuView:self didSelectedAtIndex:sender.tag];
    }
}

@end
