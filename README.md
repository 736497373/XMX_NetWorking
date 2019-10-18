# XMX_NetWorking

[![CI Status](https://img.shields.io/travis/736497373/XMX_AliYunOSS.svg?style=flat)](https://travis-ci.org/736497373/XMX_NetWorking)
[![Version](https://img.shields.io/cocoapods/v/XMX_AliYunOSS.svg?style=flat)](https://cocoapods.org/pods/XMX_NetWorking)
[![License](https://img.shields.io/cocoapods/l/XMX_AliYunOSS.svg?style=flat)](https://cocoapods.org/pods/XMX_NetWorking)
[![Platform](https://img.shields.io/cocoapods/p/XMX_AliYunOSS.svg?style=flat)](https://cocoapods.org/pods/XMX_NetWorking)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

XMX_NetWorking is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XMX_NetWorking' ,:git => 'https://github.com/736497373/XMX_NetWorking'

```

## Usage

### 基础配置
```ruby

// 配置baseUrl
[XMXNetWorkingConfigManager sharedInstance].baseUrl = BaseUrl;

// 配置log
[XMXNetWorkingConfigManager sharedInstance].consoleLog = YES;

// 标示成功键值
[XMXNetWorkingConfigManager sharedInstance].successKey = @"code";

// 成功状态码
[XMXNetWorkingConfigManager sharedInstance].successValue = @"200";
```


### 请求添加参数
```ruby

// 每次请求添加默认参数
[XMXNetWorkingConfigManager sharedInstance].generalParametersBlocks = ^(NSMutableDictionary *parameters) {

};


// 每次请求Headers添加参数
[XMXNetWorkingConfigManager sharedInstance].generalHeadersBlocks = ^(NSMutableDictionary<NSString *,NSString *> *generalHeaders) {

};
```



### 错误回调
```ruby

/// 定义业务错误,在此处统一处理，忽略错误，提供错误回调、提示之类动作
[XMXNetWorkingConfigManager sharedInstance].serverFailureCallback  = ^(NSDictionary *resultDic) {

};


/// 请求失败回调 relativeURL 失败接口 error 错误
[XMXNetWorkingConfigManager sharedInstance].requestFailureCallback = ^(NSString *relativeURL, NSError *error) {

};
```


## Author



736497373, 736497373@qq.com

## License

XMX_AliYunOSS is available under the MIT license. See the LICENSE file for more info.
