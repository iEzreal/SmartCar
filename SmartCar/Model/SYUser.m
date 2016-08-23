//
//  SYUser.m
//  SmartCar
//
//  Created by xxx on 16/7/5.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import "SYUser.h"

@implementation SYUser

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (!(self = [super init])) {
        return nil;
    }
    
    _userId = [dic objectForKey:@"id"];
    _loginName = [dic objectForKey:@"LoginName"];
    _password = [dic objectForKey:@"password"];
    _userName = [dic objectForKey:@"UserName"];
    _phone1 = [dic objectForKey:@"phone1"];
    _phone2 = [dic objectForKey:@"phone2"];
    _phone3 = [dic objectForKey:@"phone3"];
    _company = [dic objectForKey:@"company"];
    _address = [dic objectForKey:@"address"];
    _email = [dic objectForKey:@"email"];
    _remark = [dic objectForKey:@"remark"];
    
    return self;
}

@end
