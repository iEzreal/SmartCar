//
//  SYApiServer.h
//  SmartCar
//
//  Created by xxx on 16/7/5.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYApiServer : NSObject

+ (void)login:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)PWD_POST:(NSString *)method parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)POST:(NSString *)method parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)OBD_POST:(NSString *)method parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
