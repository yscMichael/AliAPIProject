//
//  SPCNetWorkManager.m
//  HYBiPad
//
//  Created by 杨世川 on 2018/7/6.
//  Copyright © 2018年 winwayworld. All rights reserved.
//

#import "SPCNetWorkManager.h"
//网络请求超时时间
static float WWTimeoutInterval = 30.0;

@implementation SPCNetWorkManager

//单例
+ (instancetype)sharedManager
{
    static SPCNetWorkManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:SPCBaseUrl]];
    });
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        //设置超时时间
        self.requestSerializer.timeoutInterval = WWTimeoutInterval;
        //设置缓存策略
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        //设置请求格式
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //设置返回格式
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain", nil];
        //设置安全策略
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

//发起网络请求
- (void)sendRequestWithMethod:(HTTPMethod)method
                     WithPath:(NSString *)path
                   WithParams:(NSDictionary*)params
             WithSuccessBlock:(void(^)(NSDictionary *result))success
              WithFailurBlock:(void(^)(NSError *error))failure
{
    //添加来源字段
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    [resultParams setValue:[NSNumber numberWithInt:5] forKey:@"source"];
    switch (method)
    {
        case HTTPMethodGet:
        {
            [self sendGetRequestWithPath:path WithParams:resultParams WithSuccessBlock:success WithFailurBlock:failure];
        }
            break;
        case HTTPMethodPost:
        {
            [self sendPostRequestWithPath:path WithParams:resultParams WithSuccessBlock:success WithFailurBlock:failure];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 发起get请求
- (void)sendGetRequestWithPath:(NSString *)path
                   WithParams:(NSDictionary*)params
             WithSuccessBlock:(void(^)(NSDictionary *result))success
               WithFailurBlock:(void(^)(NSError *error))failure
{
    [self GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
        failure(error);
    }];
}

#pragma mark - 发起post请求
- (void)sendPostRequestWithPath:(NSString *)path
                    WithParams:(NSDictionary*)params
              WithSuccessBlock:(void(^)(NSDictionary *result))success
               WithFailurBlock:(void(^)(NSError *error))failure
{
    [self POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
        failure(error);
    }];
}
@end
