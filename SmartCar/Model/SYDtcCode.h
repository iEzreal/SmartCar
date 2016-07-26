//
//  SYDtcCode.h
//  SmartCar
//
//  Created by Ezreal on 16/7/26.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYDtcCode : NSObject

@property(nonatomic, strong) NSString *dtcCode;
@property(nonatomic, strong) NSString *explain;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
