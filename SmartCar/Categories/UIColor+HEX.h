//
//  UIColor+HEX.h
//  SmartCar
//
//  Created by Ezreal on 16/7/4.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HEX)

+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
- (NSString *)HEXString;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;

@end
