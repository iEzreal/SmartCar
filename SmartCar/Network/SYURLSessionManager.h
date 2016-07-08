//
//  SYURLSessionManager.h
//  SmartCar
//
//  Created by Ezreal on 16/7/3.
//  Copyright © 2016年 Ezreal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(id responseData, NSError *error);


@interface SYURLSessionManager : NSObject

@property(nonatomic, copy) ResultBlock resultBlock;

- (instancetype)initWithAuthName:(NSString *)authName authPwd:(NSString *)authPwd;
- (void)POST:(NSString *)URLString parameters:(id)parameters resultBlock:(ResultBlock)resultBlock;

@end
