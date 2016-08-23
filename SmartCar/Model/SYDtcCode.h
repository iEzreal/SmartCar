//
//  SYDtcCode.h
//  SmartCar
//
//  Created by xxx on 16/7/26.
//  Copyright © 2016年 上海圣禹电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYDtcCode : NSObject

@property(nonatomic, strong) NSString *dtcCode;
@property(nonatomic, strong) NSString *explain;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
