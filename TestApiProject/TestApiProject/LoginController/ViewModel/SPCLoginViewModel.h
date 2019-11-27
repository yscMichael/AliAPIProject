//
//  SPCLoginViewModel.h
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/27.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPCLoginViewModel : NSObject
//判断当前token有效期
- (void)judgeTokenIsExpireSuccess:(void(^)(void))success failure:(void(^)(void))failure;
//获取验证码
- (void)getGetVerificationCodeWithParam:(NSDictionary *)param success:(void(^)(void))success failure:(void(^)(NSString *error))failure;
//登陆接口
- (void)loginWithParam:(NSDictionary *)param success:(void(^)(NSString *authCode))success failure:(void(^)(NSString *error))failure;
//登陆成功后，刷新用户token
- (void)refrshUserTokenWithParam:(NSDictionary *)param Success:(void(^)(void))success failure:(void(^)(NSString *error))failure;
@end

NS_ASSUME_NONNULL_END
