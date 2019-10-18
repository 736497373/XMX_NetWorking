//
//  XMXNetWorkingUtils.m
//  XMXNetWorkingDemo
//
//  Created by Xiemaoxiong on 2017/4/7.
//  Copyright © 2017年 谢茂雄. All rights reserved.
//

#import "XMXNetWorkingUtils.h"
#import <AFNetworking/AFNetworking.h>
#import "XMXNetWorkingConfigManager.h"


#define XMXLog(...) printf("%s\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String])

static XMXNetWorkingUtils *sharedInstance = nil;

@implementation XMXNetWorkingUtils


+ (XMXNetWorkingUtils *)sharedInstance{
    @synchronized(self) {
        if (!sharedInstance) {
            return [[self alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone{
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return  nil;
}

- (id)copyWithZone: (NSZone *)zone{
    return self;
}
/**
 通用请求入口

 @param RelativeURL 接口
 @param Mode 请求类型
 @param Parameter 参数
 @param SuccessCallBack 成功回调
 @param FailureCallback 失败回调
 */
- (void)XMX_RelativeURL:(NSString *)RelativeURL
                  Mode:(NetworkMode)Mode
             Parameter:(NSDictionary *)Parameter
       SuccessCallBack:(XMXSuccessCallback)SuccessCallBack
       FailureCallback:(XMXFailureCallback)FailureCallback {

    NSMutableDictionary *parameterMutableDic = [NSMutableDictionary dictionaryWithDictionary:Parameter];

    if ([XMXNetWorkingConfigManager sharedInstance].generalParametersBlocks) {
        [XMXNetWorkingConfigManager sharedInstance].generalParametersBlocks(parameterMutableDic);
    }
    switch (Mode) {
        case NetworkMode_GET: {
            [self XMX_GET_RelativeURL:RelativeURL
                           Parameter:parameterMutableDic
                     SuccessCallBack:SuccessCallBack
                     FailureCallback:FailureCallback];
        }break;
        case NetworkMode_POST: {
            [self XMX_POST_RelativeURL:RelativeURL
                            Parameter:parameterMutableDic
                    customContentType:nil
                      SuccessCallBack:SuccessCallBack
                      FailureCallback:FailureCallback];
        }break;
        case NetworkMode_POST_ApplicationJson: {
            [self XMX_POST_RelativeURL:RelativeURL
                            Parameter:parameterMutableDic
                    customContentType:@"application/json"
                      SuccessCallBack:SuccessCallBack
                      FailureCallback:FailureCallback];
        }break;
        case NetworkMode_DELETE: {
            [self XMX_DELETE_RelativeURL:RelativeURL
                              Parameter:parameterMutableDic
                        SuccessCallBack:SuccessCallBack
                        FailureCallback:FailureCallback];
        }break;
        default:
            break;
    }
    
}


/**
 BridgeRequest通用请求入口
 
 @param BaseURL 端口
 @param RelativeURL 接口
 @param Mode 请求类型
 @param Parameter 参数
 @param SuccessCallBack 成功回调
 @param FailureCallback 失败回调
 */
- (void)XMX_BridgeRequest_BaseURL:(NSString *)BaseURL
                     RelativeURL:(NSString *)RelativeURL
                            Mode:(NetworkMode)Mode
                       Parameter:(NSDictionary *)Parameter
                 SuccessCallBack:(XMXSuccessCallback)SuccessCallBack
                 FailureCallback:(XMXFailureCallback)FailureCallback {
    NSMutableDictionary *parameterMutableDic = [NSMutableDictionary dictionaryWithDictionary:Parameter];
    
    if ([XMXNetWorkingConfigManager sharedInstance].generalParametersBlocks) {
        [XMXNetWorkingConfigManager sharedInstance].generalParametersBlocks(parameterMutableDic);
    }

      AFHTTPSessionManager *manager = [self customHttpManagerWithUri:[BaseURL stringByAppendingString:RelativeURL]];

    switch (Mode) {
        case NetworkMode_GET: {
          
            [manager GET:[BaseURL stringByAppendingString:RelativeURL]
              parameters:Parameter
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     [self XMX_HttpURLString:[BaseURL stringByAppendingString:RelativeURL] Parameter:Parameter SuccessTask:task ResponseObject:responseObject SuccessCallBack:SuccessCallBack FailureCallback:FailureCallback];
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSMutableDictionary *callBackDic = [NSMutableDictionary dictionary];
                     [callBackDic setValue:@(500) forKey:@"code"];
                     [callBackDic setValue:@"请求失败" forKey:@"message"];
                     if (FailureCallback) {
                         FailureCallback(callBackDic);
                     }
                 }];
        }break;
        case NetworkMode_POST: {
            [manager POST:[BaseURL stringByAppendingString:RelativeURL]
               parameters:Parameter
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      [self XMX_HttpURLString:[BaseURL stringByAppendingString:RelativeURL] Parameter:Parameter SuccessTask:task ResponseObject:responseObject SuccessCallBack:SuccessCallBack FailureCallback:FailureCallback];
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      NSMutableDictionary *callBackDic = [NSMutableDictionary dictionary];
                      [callBackDic setValue:@(500) forKey:@"code"];
                      [callBackDic setValue:@"请求失败" forKey:@"message"];
                      if (FailureCallback) {
                          FailureCallback(callBackDic);
                      }
                  }];
        }break;
        case NetworkMode_POST_ApplicationJson: {
            
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                NSMutableDictionary *generalHeadersBlocks = [NSMutableDictionary dictionary];
                if ([XMXNetWorkingConfigManager sharedInstance].generalHeadersBlocks) {
                    [XMXNetWorkingConfigManager sharedInstance].generalHeadersBlocks(generalHeadersBlocks);
                }
                
                if ([generalHeadersBlocks allKeys].count > 0) {
                    [generalHeadersBlocks enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
                    }];
                }
            [manager POST:[BaseURL stringByAppendingString:RelativeURL]
               parameters:Parameter
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      [self XMX_HttpURLString:[BaseURL stringByAppendingString:RelativeURL] Parameter:Parameter SuccessTask:task ResponseObject:responseObject SuccessCallBack:SuccessCallBack FailureCallback:FailureCallback];
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      NSMutableDictionary *callBackDic = [NSMutableDictionary dictionary];
                      [callBackDic setValue:@(500) forKey:@"code"];
                      [callBackDic setValue:@"请求失败" forKey:@"message"];
                      if (FailureCallback) {
                          FailureCallback(callBackDic);
                      }
                  }];
            
        }break;

        default:
            break;
    }
    
    
    
}

/**
 GET请求
 
 @param RelativeURL 接口
 @param Parameter 参数
 @param SuccessCallBack 成功回调
 @param FailureCallback 失败回调
 */
- (void)XMX_GET_RelativeURL:(NSString *)RelativeURL
                 Parameter:(NSDictionary *)Parameter
           SuccessCallBack:(XMXSuccessCallback)SuccessCallBack
           FailureCallback:(XMXFailureCallback)FailureCallback {
    
    AFHTTPSessionManager *manager = [self customHttpManagerWithUri:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL]];
    
    [manager GET:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL]
      parameters:Parameter
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self XMX_HttpURLString:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL] Parameter:Parameter SuccessTask:task ResponseObject:responseObject SuccessCallBack:SuccessCallBack FailureCallback:FailureCallback];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self XMX_HttpErrorTask:task Error:error RelativeURL:RelativeURL FailureCallback:FailureCallback];
    }];
}




/**
 POST_请求
 
 @param RelativeURL 接口
 @param Parameter 参数
 @param SuccessCallBack 成功回调
 @param FailureCallback 失败回调
 */
- (void)XMX_POST_RelativeURL:(NSString *)RelativeURL
                              Parameter:(NSDictionary *)Parameter
                        customContentType:(NSString *)customContentType
                        SuccessCallBack:(XMXSuccessCallback)SuccessCallBack
                        FailureCallback:(XMXFailureCallback)FailureCallback {
    
    AFHTTPSessionManager *manager = [self customHttpManagerWithUri:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL]];

    if (customContentType.length > 0) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:customContentType forHTTPHeaderField:@"Content-Type"];
         NSMutableDictionary *generalHeadersBlocks = [NSMutableDictionary dictionary];
        if ([XMXNetWorkingConfigManager sharedInstance].generalHeadersBlocks) {
            [XMXNetWorkingConfigManager sharedInstance].generalHeadersBlocks(generalHeadersBlocks);
        }
        
        if ([generalHeadersBlocks allKeys].count > 0) {
            [generalHeadersBlocks enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
            }];
        }
    }
    
        [manager POST:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL]
           parameters:Parameter
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self XMX_HttpURLString:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL] Parameter:Parameter SuccessTask:task ResponseObject:responseObject SuccessCallBack:SuccessCallBack FailureCallback:FailureCallback];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  [self XMX_HttpErrorTask:task Error:error RelativeURL:RelativeURL FailureCallback:FailureCallback];
        }];
    
}



/**
 PUT请求
 
 @param RelativeURL 接口
 @param Parameter 参数
 @param SuccessCallBack 成功回调
 @param FailureCallback 失败回调
 */
- (void)XMX_PUT_RelativeURL:(NSString *)RelativeURL
                              Parameter:(NSDictionary *)Parameter
                        SuccessCallBack:(XMXSuccessCallback)SuccessCallBack
                        FailureCallback:(XMXFailureCallback)FailureCallback {
    
    AFHTTPSessionManager *manager = [self customHttpManagerWithUri:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL]];
    
    [manager PUT:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL]
      parameters:Parameter
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          [self XMX_HttpURLString:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL] Parameter:Parameter SuccessTask:task ResponseObject:responseObject SuccessCallBack:SuccessCallBack FailureCallback:FailureCallback];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self XMX_HttpErrorTask:task Error:error RelativeURL:RelativeURL FailureCallback:FailureCallback];
    }];
}



/**
 DELETE请求
 
 @param RelativeURL 接口
 @param Parameter 参数
 @param SuccessCallBack 成功回调
 @param FailureCallback 失败回调
 */
- (void)XMX_DELETE_RelativeURL:(NSString *)RelativeURL
                 Parameter:(NSDictionary *)Parameter
           SuccessCallBack:(XMXSuccessCallback)SuccessCallBack
           FailureCallback:(XMXFailureCallback)FailureCallback {
    
    AFHTTPSessionManager *manager = [self customHttpManagerWithUri:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL]];
    
    [manager DELETE:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL]
         parameters:Parameter
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self XMX_HttpURLString:[[XMXNetWorkingConfigManager sharedInstance].baseUrl stringByAppendingString:RelativeURL] Parameter:Parameter SuccessTask:task ResponseObject:responseObject SuccessCallBack:SuccessCallBack FailureCallback:FailureCallback];
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self XMX_HttpErrorTask:task Error:error RelativeURL:RelativeURL FailureCallback:FailureCallback];
          }];
}

- (AFSecurityPolicy*)customSecurityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setPinnedCertificates:[NSSet setWithArray:@[[XMXNetWorkingConfigManager sharedInstance].sslcert]]];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    return securityPolicy;
}


- (void)saveTokenWithURLSessionDataTask:(NSURLSessionDataTask *)task {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
    if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        if ([[dictionary allKeys] containsObject:@"token"]) {
            [[NSUserDefaults standardUserDefaults] setValue:dictionary[@"token"] forKey:@"XMXtoken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            XMXLog(@"token = %@",dictionary[@"token"]);
            
        }
    }
}


- (void)XMX_HttpURLString:(NSString *)URLString
               Parameter:(NSDictionary *)Parameter
             SuccessTask:(NSURLSessionDataTask * _Nonnull)Task
            ResponseObject:(id  _Nullable)ResponseObject
           SuccessCallBack:(XMXSuccessCallback)SuccessCallBack
           FailureCallback:(XMXFailureCallback)FailureCallback {
        [self saveTokenWithURLSessionDataTask:Task];
    
    NSDictionary *resultDictionary;
    
    if ([ResponseObject isKindOfClass:[NSDictionary class]]) {
        resultDictionary = ResponseObject;
    }else {
        resultDictionary = [NSJSONSerialization JSONObjectWithData:ResponseObject options:NSUTF8StringEncoding error:nil];
    }
    
    
    
    NSString *successKey;
    
    XMXLog(@"%@-----XMXNetWorkUtils-----\n-----网络请求->\n%@?%@ \n-----请求数据->\n%@ \n-----请求返回数据 ->\n %@ \n-----请求返回数据解析 ->\n %@",[self currentTimeStr],URLString,[Cryptor serialParameterDictionary:Parameter],Parameter,resultDictionary,[[NSString alloc] initWithData:ResponseObject encoding:NSUTF8StringEncoding]);
    
    if ([resultDictionary[[XMXNetWorkingConfigManager sharedInstance].successKey] isKindOfClass:[NSString class]]) {
        successKey = resultDictionary[[XMXNetWorkingConfigManager sharedInstance].successKey];
    }else  {
        successKey = [resultDictionary[[XMXNetWorkingConfigManager sharedInstance].successKey] stringValue];
    }
    
    /// 判断是否成功
    if ([successKey isEqualToString:[XMXNetWorkingConfigManager sharedInstance].successValue]) {
        if (SuccessCallBack) {
            SuccessCallBack(resultDictionary);
        }
    }else {
        /// 如果有错误回调执行回调
        if (FailureCallback) {
            FailureCallback(resultDictionary);
        }
        if ([XMXNetWorkingConfigManager sharedInstance].serverFailureCallback) {
            [XMXNetWorkingConfigManager sharedInstance].serverFailureCallback(resultDictionary);
        }
    
    }
}

- (void)XMX_HttpErrorTask:(NSURLSessionDataTask * _Nonnull)Task Error:(NSError *)error RelativeURL:(NSString *)RelativeURL FailureCallback:(XMXFailureCallback)FailureCallback{
    if (FailureCallback) {
        FailureCallback(@{@"msg" : @"网络错误"});
    }else if ([XMXNetWorkingConfigManager sharedInstance].requestFailureCallback) {
        [XMXNetWorkingConfigManager sharedInstance].requestFailureCallback(RelativeURL,error);
    }
}


- (AFHTTPSessionManager *)customHttpManagerWithUri:(NSString *)uri {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer  = [AFHTTPResponseSerializer serializer];//返回的格式是text/plain
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    
    NSMutableDictionary *generalHeadersBlocks = [NSMutableDictionary dictionary];
    
    if ([XMXNetWorkingConfigManager sharedInstance].generalHeadersBlocks) {
        [XMXNetWorkingConfigManager sharedInstance].generalHeadersBlocks(generalHeadersBlocks);
    }
    
    if ([generalHeadersBlocks allKeys].count > 0) {
        [generalHeadersBlocks enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }

     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    if ( [XMXNetWorkingConfigManager sharedInstance].sslcert != nil) {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    return manager;
}

- (NSString *)currentTimeStr {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
    return [formatter stringFromDate:date];
}


@end

@implementation Cryptor


/**
 字典转key=value&key=value字符串
 
 @param parameterDictionary 字典
 @return 字符串
 */
+ (NSString *)serialParameterDictionary:(NSDictionary *)parameterDictionary
{
    NSEnumerator * enumeratorKey = [parameterDictionary keyEnumerator];
    NSString *serialString=@"";
    for (NSString *key in enumeratorKey)
    {
        if (serialString.length==0)
        {
            serialString=[NSString stringWithFormat:@"%@=%@",key,parameterDictionary[key]];
        }
        else
        {
            serialString=[NSString stringWithFormat:@"%@&%@=%@",serialString,key,parameterDictionary[key]];
        }
    }
    
    return serialString;
}




@end
