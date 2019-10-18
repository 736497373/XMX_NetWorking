//
//  XMXNetWorkingUtils.h
//  XMXNetWorkingDemo
//
//  Created by Xiemaoxiong on 2017/4/7.
//  Copyright © 2017年 谢茂雄. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MyString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define  XMXLog(...) printf(" %s 第%d行: %s\n\n",[MyString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

typedef NS_ENUM(NSInteger,NetworkMode)
{
   NetworkMode_GET,
   NetworkMode_POST,
   NetworkMode_POST_ApplicationJson,
   NetworkMode_PUT,
   NetworkMode_DELETE
};

typedef void  (^XMXSuccessDataEmptyCallback)(void);
typedef void  (^XMXSuccessCallback)(NSDictionary *resultDic);
typedef void  (^XMXFailureCallback)(NSDictionary *resultDic);
typedef void  (^XMXErrorCallback)(NSError *error);




#define REQUEST_CONTENT_TYPE                @"Content-Type"
#define REQUEST_CONTENT_TYPE_VALUE          @"application/x-www-form-urlencoded;charset=utf8;text/html"





@interface XMXNetWorkingUtils : NSObject

+ (XMXNetWorkingUtils *)sharedInstance;


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
           FailureCallback:(XMXFailureCallback)FailureCallback;



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
                 FailureCallback:(XMXFailureCallback)FailureCallback;

@end




@interface Cryptor : NSObject

/**
 字典转key=value&key=value字符串
 
 @param parameterDictionary 字典
 @return 字符串
 */
+ (NSString *)serialParameterDictionary:(NSDictionary *)parameterDictionary;
@end
