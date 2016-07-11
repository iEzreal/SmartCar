//
//  SYMineMenuCell.m
//  SmartCar
//
//  Created by liuyiming on 16/7/9.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYMineMenuCell.h"

@interface SYMineMenuCell ()

@property(nonatomic, strong) NSArray *menuArray;

@end

@implementation SYMineMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        return self;
    }
    
    _menuArray = [[NSArray alloc] init];
    NSArray *imageArray = @[@"mine_upwd", @"mine_personal", @"mine_milestage",
                            @"mine_afterservice ", @"mine_softupdate"];
    NSArray *titleArray = @[@"修改密码", @"个人信息", @"初始里程",
                            @"关于我们", @"版本信息"];
    // 总共5个 分3列
    for (int i = 0; i < 5; i++) {
        long rowIndex = i / 3;
        long columnIndex = i % 3;
        
        CGFloat w =  SCREEN_W / 3;
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
        [menuItem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:menuItem];
    }
    
    return self;
}

- (void)itemClick:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
