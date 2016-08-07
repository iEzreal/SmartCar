//
//  SYUser.h
//  SmartCar
//
//  Created by liuyiming on 16/7/5.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYUser : NSObject

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *loginTime;
@property(nonatomic, strong) NSString *loginName;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *phone1;
@property(nonatomic, strong) NSString *phone2;
@property(nonatomic, strong) NSString *phone3;
@property(nonatomic, strong) NSString *company;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *remark;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
