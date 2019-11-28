//
//  SPCNetWorkManager.h
//  HYBiPad
//
//  Created by 杨世川 on 2018/7/6.
//  Copyright © 2018年 winwayworld. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef NS_ENUM (NSInteger, HTTPMethod){
    HTTPMethodGet,//get请求
    HTTPMethodPost,//post请求
};

@interface SPCNetWorkManager : AFHTTPSessionManager
@property(nonatomic,copy) NSString *access_token;

//单例
+ (instancetype)sharedManager;

//设置请求头内容
- (void)setAccessTokenWithString:(NSString *)accessToken;

//发起业务网络请求(参数在body内)
- (void)startRequestWithUrl:(NSString *)url
                     method:(HTTPMethod) method
                     params:(NSDictionary *)params
           withSuccessBlock:(void(^)(NSDictionary *result))success
            withFailurBlock:(void(^)(NSError *error))failure;
//发起业务网络请求(参数在param内)
- (void)sendRequestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(void(^)(NSDictionary *result))success
          WithFailurBlock:(void(^)(NSError *error))failure;

//
- (void)tempStartRequestWithUrl:(NSString *)url
          method:(HTTPMethod) method
          params:(NSDictionary *)params
withSuccessBlock:(void(^)(NSDictionary *result))success
                withFailurBlock:(void(^)(NSError *error))failure;

@end
