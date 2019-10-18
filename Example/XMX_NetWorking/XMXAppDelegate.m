//
//  XMXAppDelegate.m
//  XMX_NetWorking
//
//  Created by 736497373 on 10/18/2019.
//  Copyright (c) 2019 736497373. All rights reserved.
//

#import "XMXAppDelegate.h"
#import <XMXNetWorkingConfigManager.h>
#ifdef DEBUG
static NSString *const BaseUrl = @"";
#else
static NSString *const BaseUrl = @"";
#endif

@implementation XMXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    // 配置baseUrl
    [XMXNetWorkingConfigManager sharedInstance].baseUrl = BaseUrl;
    // 配置log
    [XMXNetWorkingConfigManager sharedInstance].consoleLog = YES;
    // 标示成功键值
    [XMXNetWorkingConfigManager sharedInstance].successKey = @"code";
    // 成功状态码
    [XMXNetWorkingConfigManager sharedInstance].successValue = @"200";
    
    
    // 每次请求添加默认参数
    [XMXNetWorkingConfigManager sharedInstance].generalParametersBlocks = ^(NSMutableDictionary *parameters) {
   
    };
    
    // 每次请求Headers添加参数
    [XMXNetWorkingConfigManager sharedInstance].generalHeadersBlocks = ^(NSMutableDictionary<NSString *,NSString *> *generalHeaders) {
 
    };
    
    /// 定义业务错误,在此处统一处理，忽略错误，提供错误回调、提示之类动作
    [XMXNetWorkingConfigManager sharedInstance].serverFailureCallback  = ^(NSDictionary *resultDic) {

    };
    
    
    /// 请求失败回调 relativeURL 失败接口 error 错误
    [XMXNetWorkingConfigManager sharedInstance].requestFailureCallback = ^(NSString *relativeURL, NSError *error) {
   
    };
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
