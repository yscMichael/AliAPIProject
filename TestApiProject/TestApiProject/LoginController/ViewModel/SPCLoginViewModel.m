//
//  SPCLoginViewModel.m
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/27.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "SPCLoginViewModel.h"

//判断token有效期
NSString *const SPCExpireToken = @"/api/skyworth-northbound/checkToken/checkTokenTime";
//获取验证码
NSString *const SPCGetVerificationCode = @"/api/skyworth-northbound/users/captcha";
//登陆
NSString *const SPCLogin = @"/api/skyworth-northbound/users/skyworthdigitallogin";
//刷新token
NSString *const SPCRefreshToken = @"/api/skyworth-northbound/users/refreshToken";

@interface SPCLoginViewModel()

@end

@implementation SPCLoginViewModel
#pragma mark - 判断当前token有效期
- (void)judgeTokenIsExpireSuccess:(void(^)(void))success failure:(void(^)(void))failure{
    
}

#pragma mark - 获取验证码
- (void)getGetVerificationCodeWithParam:(NSDictionary *)param success:(void(^)(void))success failure:(void(^)(NSString *error))failure{
    [[SPCNetWorkManager sharedManager] startRequestWithUrl:SPCGetVerificationCode method:HTTPMethodPost params:param withSuccessBlock:^(NSDictionary *result) {
        success();
    } withFailurBlock:^(NSError *error) {
        failure(@"网络请求失败");
    }];
}

#pragma mark - 登陆接口
- (void)loginWithParam:(NSDictionary *)param success:(void(^)(NSString *authCode))success failure:(void(^)(NSString *error))failure{
    WeakSelf;
    [[SPCNetWorkManager sharedManager] startRequestWithUrl:SPCLogin method:HTTPMethodPost params:param withSuccessBlock:^(NSDictionary *result) {
        if ([result[@"code"] intValue] == 200) {
            NSDictionary *data = result[@"data"];
            NSString *authCode = data[@"open_id"];
            NSLog(@"登陆接口 = %@",authCode);
//            weakSelf.access_token = data[@"access_token"];
            //后面登陆使用
            [SPCNetWorkManager sharedManager].access_token = data[@"access_token"];
            weakSelf.refresh_token = data[@"refresh_token"];
            success(authCode);
        }else{
            failure(@"网络请求失败");
        }
    } withFailurBlock:^(NSError *error) {
        failure(@"网络请求失败");
    }];
}

#pragma mark - 登陆成功后，刷新用户token
- (void)refreshUserTokenSuccess:(void(^)(void))success failure:(void(^)(NSString *error))failure{
    NSDictionary *params = @{
        @"grant_type":@"refresh_token",
        @"refresh_token":self.refresh_token
    };
    
    [[SPCNetWorkManager sharedManager] tempStartRequestWithUrl:SPCRefreshToken method:HTTPMethodPost params:params withSuccessBlock:^(NSDictionary *result) {
        
    } withFailurBlock:^(NSError *error) {
        
    }];
    
//    [[SPCNetWorkManager sharedManager] sendRequestWithMethod:HTTPMethodPost WithPath:SPCRefreshToken WithParams:params WithSuccessBlock:^(NSDictionary *result) {
//
//    } WithFailurBlock:^(NSError *error) {
//
//    }];
}


@end
