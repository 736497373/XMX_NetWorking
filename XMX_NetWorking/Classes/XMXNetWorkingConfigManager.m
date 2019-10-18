//
//  XMXNetWorkingConfigManager.m
//  XMXNetWorkingDemo
//
//  Created by Xiemaoxiong on 2017/4/10.
//  Copyright © 2017年 谢茂雄. All rights reserved.
//

#import "XMXNetWorkingConfigManager.h"

@implementation XMXNetWorkingConfigManager

+ (XMXNetWorkingConfigManager *)sharedInstance
{
    static XMXNetWorkingConfigManager* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMXNetWorkingConfigManager alloc] init];
    });
    
    return instance;
}


@end
