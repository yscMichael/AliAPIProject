//
//  LoginController.m
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/25.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "LoginController.h"
#import "HomeListController.h"
#import "SPCLoginViewModel.h"
#import <IMSAccount/IMSAccountService.h>
#import <ALBBOpenAccountSSO/ALBBOpenAccountSSOSDK.h>

@interface LoginController ()<SSODelegate>
//输入验证码
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
//网络请求
@property(nonatomic,strong) SPCLoginViewModel *loginViewModel;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    [self initAccountFramework];
}

#pragma mark - 初始化账号SDK
- (void)initAccountFramework{
    [[SPCCommonInitTool sharedManager] initALBBOpenAccountSDK];
}

#pragma mark - 点击验证码按钮
- (IBAction)clickVerificationCodeButton:(UIButton *)sender {
    NSDictionary *phoneDict = @{
        @"phone":SPCPhone
    };
    [self.loginViewModel getGetVerificationCodeWithParam:phoneDict success:^{

    } failure:^(NSString * _Nonnull error) {

    }];
}

#pragma mark - 点击登陆按钮
- (IBAction)clickLoginButton:(UIButton *)sender {
    //登陆
    NSDictionary *loginDict = @{
        @"username": SPCPhone,
        @"password": self.codeTextField.text,
        @"grant_type": @"password",
        @"scope": @"all",
        @"type": @"account"
    };
    
    WeakSelf;
    [self.loginViewModel loginWithParam:loginDict success:^(NSString * _Nonnull authCode) {
        [weakSelf dealopenIdAndAuthCodeWithString:authCode];
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

#pragma mark - 获取open_id、进行阿里授权
- (void)dealopenIdAndAuthCodeWithString:(NSString *)authCode{
    NSLog(@"authCode = %@",authCode);
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

#pragma mark - Getter And Setter
- (SPCLoginViewModel *)loginViewModel{
    if (!_loginViewModel) {
        _loginViewModel = [[SPCLoginViewModel alloc] init];
    }
    return _loginViewModel;
}

@end

