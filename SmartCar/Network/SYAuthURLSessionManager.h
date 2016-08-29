//
//  SYAuthURLSessionManager.h
//  SmartCar
//
//  Created by xxx on 16/7/3.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(id responseData, NSError *error);


@interface SYAuthURLSessionManager : NSObject

@property(nonatomic, copy) ResultBlock resultBlock;

- (instancetype)initWithAuthName:(NSString *)authName authPwd:(NSString *)authPwd;
- (void)POST:(NSString *)URLString parameters:(id)parameters resultBlock:(ResultBlock)resultBlock;

@end

