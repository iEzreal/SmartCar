//
//  SYURLSessionManager.m
//  SmartCar
//
//  Created by Ezreal on 16/7/12.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYURLSessionManager.h"

@interface SYURLSessionManager () <NSURLSessionDelegate ,NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property(nonatomic, strong) NSURLSession *session;
@property(nonatomic, strong) NSMutableData *mutableData;

@end

@implementation SYURLSessionManager

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
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
    [request setHTTPBody:bodyData];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    
}


#pragma mark - NSURLSessionDataDelegate;
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
