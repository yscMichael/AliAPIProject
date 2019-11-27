//
//  LoginController.m
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/25.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "LoginController.h"
#import "HomeListController.h"
#import <ALBBOpenAccountSSO/ALBBOpenAccountSSOSDK.h>
#import <IMSAccount/IMSAccountService.h>
#import <IMSApiClient/IMSConfiguration.h>

//获取验证码
NSString *const SPCGetVerificationCode = @"/api/skyworth-northbound/users/captcha";
//登陆
NSString *const SPCLogin = @"/api/skyworth-northbound/users/skyworthdigitallogin";

@interface LoginController ()<SSODelegate>
//输入验证码
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    [self initAccountFramework];
    NSLog(@"当前是登陆界面");
}

#pragma mark - 点击登陆按钮
- (IBAction)clickButton:(UIButton *)sender {
    
    NSDictionary *tempDict = @{
        @"phone":SPCPhone
    };
    [[SPCNetWorkManager sharedManager] startRequestWithUrl:SPCGetVerificationCode method:HTTPMethodPost params:tempDict withSuccessBlock:^(NSDictionary *result) {
        
    } withFailurBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 初始化账号SDK
- (void)initAccountFramework{
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

#pragma makr - 点击登陆按钮
- (IBAction)clickLoginButton:(UIButton *)sender {
    //登陆
    NSDictionary *tempDict = @{
        @"username": SPCPhone,
        @"password": self.codeTextField.text,
        @"grant_type": @"password",
        @"scope": @"all",
        @"type": @"account"
    };
    __weak typeof(self) weakSelf = self;
    [[SPCNetWorkManager sharedManager] startRequestWithUrl:SPCLogin method:HTTPMethodPost params:tempDict withSuccessBlock:^(NSDictionary *result) {
        //如果codecode == 200,进入设备列表界面
        NSLog(@"resultresult = %@",result);
        if ([result[@"code"] intValue] == 200) {//进入设备列表界面
            // 获取open_id、进行阿里授权
            NSDictionary *data = result[@"data"];
            [weakSelf dealopenIdAndAuthCodeWithDict:data];
        }else{//提示错误
            NSLog(@"tips= %@",result[@"msg"]);
        }
    } withFailurBlock:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}

#pragma mark - 获取open_id、进行阿里授权
- (void)dealopenIdAndAuthCodeWithDict:(NSDictionary *)data{
    NSString *authCode = data[@"open_id"];
    NSLog(@"authCodeauthCode = %@",authCode);
    id<ALBBOpenAccountSSOService> ssoService = ALBBService(ALBBOpenAccountSSOService);
    [ssoService oauthWithThirdParty:authCode delegate:self];
}


#pragma mark - SSODelegate
- (void)openAccountOAuthError:(NSError *)error Session:(ALBBOpenAccountSession *)session {
    NSLog(@"SSODelegateSSODelegate");
    if (!error) {
        //1、登录成功，发送登录成功通知，身份认证 SDK 会监听该通知进行用户身份凭证创建和管理
        NSString *loginNotificationName = [[IMSAccountService sharedService].sessionProvider accountDidLoginSuccessNotificationName];
        [[NSNotificationCenter defaultCenter] postNotificationName:loginNotificationName object:nil];
        //2、进入设备列表界面
        HomeListController *homeCtrl = [[HomeListController alloc] init];
        [self.navigationController pushViewController: homeCtrl animated:YES];
    } else {
        //处理登录失败
        NSLog(@"登陆失败");
    }
}

@end

