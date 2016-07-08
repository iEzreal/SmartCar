//
//  SYApiServer.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYApiServer.h"
#import "SYURLSessionManager.h"

@implementation SYApiServer

+ (void)login:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *authName = [parameters objectForKey:@"userName"];
    NSString *authPwd = [parameters objectForKey:@"userPwd"];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", BASE_URL, METHOD_LOGIN];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:authName forKey:@"UserId"];
    
    SYURLSessionManager *manager = [[SYURLSessionManager alloc] initWithAuthName:authName authPwd:authPwd];
    [manager POST:URLString parameters:dic resultBlock:^(id responseData, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(responseData);
        }
    }];
}

+ (void)POST:(NSString *)method parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *authName = [SYAppManager sharedManager].user.loginName;
    NSString *authPwd = [SYAppManager sharedManager].user.password;
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", BASE_URL, method];
    SYURLSessionManager *manager = [[SYURLSessionManager alloc] initWithAuthName:authName authPwd:authPwd];
    [manager POST:URLString parameters:parameters resultBlock:^(id responseData, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(responseData);
        }
    }];
}

@end
