//
//  SYURLSessionManager.h
//  SmartCar
//
//  Created by liuyiming on 16/7/12.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(id responseData, NSError *error);

@interface SYURLSessionManager : NSObject

@property(nonatomic, copy) ResultBlock resultBlock;

- (void)POST:(NSString *)URLString parameters:(id)parameters resultBlock:(ResultBlock)resultBlock;

@end
