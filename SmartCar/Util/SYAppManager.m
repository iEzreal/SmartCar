//
//  SYAppManager.m
//  SmartCar
//
//  Created by Ezreal on 16/7/5.
//  Copyright © 2016年 liuyiming. All rights reserved.
//

#import "SYAppManager.h"

@implementation SYAppManager

static SYAppManager *instance = nil;
+ (SYAppManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (!(self = [super init])) {
        return self;
    }
    
    return self;
}


@end
