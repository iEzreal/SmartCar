//
//  SYButton.h
//  SmartCar
//
//  Created by liuyiming on 16/7/4.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIButtonTitleWithImageAlignmentUp = 0,  // image is up, title is down
    UIButtonTitleWithImageAlignmentLeft,    // image is left, title is right
    UIButtonTitleWithImageAlignmentDown,    // image is down, title is up
    UIButtonTitleWithImageAlignmentRight    // image is right, title is left
} UIButtonTitleWithImageAlignment;

@interface SYButton : UIButton

@property (nonatomic) CGFloat imgTextDistance;  // distance between image and title, default is 5
@property (nonatomic) UIButtonTitleWithImageAlignment buttonTitleWithImageAlignment;  // need to set a value when used

- (UIButtonTitleWithImageAlignment)buttonTitleWithImageAlignment;
- (void)setButtonTitleWithImageAlignment:(UIButtonTitleWithImageAlignment)buttonTitleWithImageAlignment;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img title:(NSString *)title;

@end
