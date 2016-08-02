//
//  SYApiServer.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYApiServer.h"
#import "SYAuthURLSessionManager.h"
#import "SYURLSessionManager.h"

@implementation SYApiServer

+ (void)login:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *authName = [parameters objectForKey:@"userName"];
    NSString *authPwd = [parameters objectForKey:@"userPwd"];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", BASE_URL, METHOD_LOGIN];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:authName forKey:@"UserId"];
    
    SYAuthURLSessionManager *manager = [[SYAuthURLSessionManager alloc] initWithAuthName:authName authPwd:authPwd];
    [manager POST:URLString parameters:dic resultBlock:^(id responseData, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(responseData);
        }
    }];
}

+ (void)PWD_POST:(NSString *)method parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure  {
    NSString *authName = @"resetpassword";
    NSString *authPwd = @"resetpassword";
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", BASE_URL, method];
    SYAuthURLSessionManager *manager = [[SYAuthURLSessionManager alloc] initWithAuthName:authName authPwd:authPwd];
    [manager POST:URLString parameters:parameters resultBlock:^(id responseData, NSError *error) {
        if (error) {
            DLog(@"----请求服务器错误：%@", error);
            failure(error);
        } else {
            DLog(@"----服务器返回结果：%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            success(responseData);
        }
    }];
}


+ (void)POST:(NSString *)method parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    NSString *authName = [SYAppManager sharedManager].user.loginName;
    NSString *authPwd = [SYAppManager sharedManager].user.password;
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", BASE_URL, method];
    SYAuthURLSessionManager *manager = [[SYAuthURLSessionManager alloc] initWithAuthName:authName authPwd:authPwd];
    [manager POST:URLString parameters:parameters resultBlock:^(id responseData, NSError *error) {
        if (error) {
            DLog(@"----请求服务器错误：%@", error);
            failure(error);
        } else {
            DLog(@"----服务器返回结果：%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            success(responseData);
        }
    }];
}

+ (void)OBD_POST:(NSString *)method parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", BASE_OBD_URL, method];
    SYURLSessionManager *manager = [[SYURLSessionManager alloc] init];
    [manager POST:URLString parameters:parameters resultBlock:^(id responseData, NSError *error) {
        if (error) {
            failure(error);
        } else {
             DLog(@"----服务器返回结果：%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            success(responseData);
        }
    }];
}


@end
