//
//  XMXNetWorkingConfigManager.h
//  XMXNetWorkingDemo
//
//  Created by Xiemaoxiong on 2017/4/10.
//  Copyright © 2017年 谢茂雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMXNetWorkingConfigManager : NSObject


+ (XMXNetWorkingConfigManager *)sharedInstance;

/**
 BaseUrl
 */
@property(nonatomic, copy) NSString *baseUrl;


/**
 接口版本
 */
@property(nonatomic, copy) NSString *apiVersion;


/**
 是否打印log
 */
@property(nonatomic, assign) Boolean consoleLog;


/**
 配置https证书
 */
@property (nonatomic,strong) NSData *sslcert;

/**
 是否成功的键
 */
@property (nonatomic,copy) NSString *successKey;


/**
 成功标识
 */
@property (nonatomic,copy) NSString *successValue;
/**
 配置默认头部
 */
@property(nonatomic,copy) void(^generalHeadersBlocks)(NSMutableDictionary <NSString *, NSString *> *generalHeaders);

/**
 配置默认参数
 */
@property(nonatomic,copy) void(^generalParametersBlocks)(NSMutableDictionary *parameters);

/**
 自定义错误回调
 */
@property (nonatomic,copy) void(^serverFailureCallback)(NSDictionary *resultDic);

/**
 请求错误回调
 */
@property (nonatomic,copy) void(^requestFailureCallback)(NSString *relativeURL,NSError *error);





@end
