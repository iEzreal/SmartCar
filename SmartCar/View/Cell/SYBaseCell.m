//
//  SYBaseCell.m
//  SmartCar
//
//  Created by xxx on 16/7/7.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYBaseCell.h"

@implementation SYBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    _lineView = [[UIImageView alloc] init];
    _lineView.image = [UIImage imageNamed:@"splitter_line"];
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(SCREEN_W);
        make.height.equalTo(@0.5);
    }];
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    }

@end
