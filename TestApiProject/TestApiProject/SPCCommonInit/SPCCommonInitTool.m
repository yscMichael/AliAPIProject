//
//  SPCCommonInitTool.m
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/27.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "SPCCommonInitTool.h"
#import <IMSLog/IMSLog.h>
#import <IMSApiClient/IMSConfiguration.h>
#import <ALBBOpenAccountSSO/ALBBOpenAccountSSOSDK.h>

@implementation SPCCommonInitTool
#pragma mark - 单例
+ (instancetype)sharedManager{
    static SPCCommonInitTool *manger = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manger = [[SPCCommonInitTool alloc] init];
    });
    return manger;
}

#pragma mark - 初始化API通道

#pragma mark - API通道
//初始化IMSConfiguration
- (void)initIMSConfiguration{
    //1、 对API通道SDK进行初始化、指定 API 通道服务器域名和环境
    [IMSConfiguration initWithHost:@"api.link.aliyun.com" serverEnv:IMSServerRelease];
    //设置安全图片的认证码
    [IMSConfiguration sharedInstance].authCode = @"07e8";
    // 设置服务端语言：zh-CN、en-US、fr-FR、de-DE、ja-JP、ko-KR、es-ES、ru-RU、hi-IN、it-IT
    [IMSConfiguration sharedInstance].language = @"zh-CN";
    
    //2、日志输出
    //统一设置所有模块的日志 tag 输出级别
    [IMSLog setAllTagsLevel:IMSLogLevelAll];
    [IMSLog showInConsole:YES];
}

#pragma mark - 账号及用户SDK
//初始化ALBBOpenAccountSDK
- (void)initALBBOpenAccountSDK{
    ALBBOpenAccountSDK *accountSDK = [ALBBOpenAccountSDK sharedInstance];
    // 设置安全图片authCode
    IMSConfiguration *conf = [IMSConfiguration sharedInstance];
    [accountSDK setSecGuardImagePostfix:conf.authCode];
    // 设置账号服务器环境，默认为线上环境
    [accountSDK setTaeSDKEnvironment:TaeSDKEnvironmentRelease];
    // 设置账号服务器域名；如果是线上环境，可以不设置域名；
    //[accountSDK setGwHost:@"sdk.openaccount.aliyun.com"];
    // 打开调试日志
    [accountSDK setDebugLogOpen:YES];
    //初始化
    [accountSDK asyncInit:^{
      // 初始化成功
        NSLog(@"accountSDK初始化成功");
    } failure:^(NSError *error) {
      // 初始化失败
        NSLog(@"accountSDK初始化失败");
    }];
}


@end
