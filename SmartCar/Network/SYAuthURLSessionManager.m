//
//  SYAuthURLSessionManager.m
//  SmartCar
//
//  Created by Ezreal on 16/7/3.
//  Copyright © 2016年 Ezreal. All rights reserved.
//

#import "SYAuthURLSessionManager.h"


@interface SYAuthURLSessionManager () <NSURLSessionDelegate ,NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property(nonatomic, strong) NSString *authName;
@property(nonatomic, strong) NSString *authPwd;

@property(nonatomic, strong) NSURLSession *session;
@property(nonatomic, strong) NSMutableData *mutableData;


@end

@implementation SYAuthURLSessionManager

- (instancetype)initWithAuthName:(NSString *)authName authPwd:(NSString *)authPwd {
    if (!(self = [super init])) {
        return nil;
    }
    
    _authName = authName;
    _authPwd = authPwd;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    self.mutableData = [[NSMutableData alloc] init];
    
    return self;
}

/**
 *  POST请求方法
 *
 *  @param URLString     请求URLString
 *  @param parameters    请求参数
 *  @param responseBlock
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters resultBlock:(ResultBlock)resultBlock {
    _resultBlock = resultBlock;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    request.timeoutInterval = 5.0;
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"content-type"];
    request.HTTPMethod = @"POST";
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    DLog(@"----提交到服务器数据：%@", str);
    
    [request setHTTPBody:bodyData];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    
}


- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    
}


#pragma mark - NSURLSessionTaskDelegate
/***************************************************************************/
/*                              身份验证                                    */
/***************************************************************************/
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    DLog(@"----身份验证");
    // 创建 NSURLCredential 对象
    NSURLCredential *urlCredential = [NSURLCredential credentialWithUser:_authName
                                                          password:_authPwd
                                                       persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, urlCredential);
}


#pragma mark - NSURLSessionDataDelegate;
/***************************************************************************/
/*                              数据接受                                    */
/***************************************************************************/
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [_mutableData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (_resultBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
             _resultBlock(_mutableData, error);
        });
    }
}


@end
