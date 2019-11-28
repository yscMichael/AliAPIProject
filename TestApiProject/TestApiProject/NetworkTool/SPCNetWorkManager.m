//
//  SPCNetWorkManager.m
//  HYBiPad
//
//  Created by 杨世川 on 2018/7/6.
//  Copyright © 2018年 winwayworld. All rights reserved.
//

#import "SPCNetWorkManager.h"
//网络请求超时时间
static float SPCTimeoutInterval = 30.0;

@implementation SPCNetWorkManager
#pragma mark - 单例
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
        self.requestSerializer.timeoutInterval = SPCTimeoutInterval;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        //设置缓存策略
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        //设置请求格式
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [self.requestSerializer setValue:@"Basic c2t5d29ydGhkaWdpdGFsOnNreXdvcnRoZGlnaXRhbF9zZWNyZXQ=" forHTTPHeaderField:@"Authorization"];
        //设置返回格式
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain", nil];
        //设置安全策略
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

#pragma mark - 设置请求头内容
- (void)setAccessTokenWithString:(NSString *)accessToken{
    [self.requestSerializer setValue:accessToken forHTTPHeaderField:@"Blade-Auth"];
}

#pragma mark - 发起网络请求(参数在Body内)
- (void)startRequestWithUrl:(NSString *)url
          method:(HTTPMethod) method
          params:(NSDictionary *)params
withSuccessBlock:(void(^)(NSDictionary *result))success
 withFailurBlock:(void(^)(NSError *error))failure{
    //1、网络请求request
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",self.baseURL,url];
    NSMutableURLRequest *request = [self dealURLRequestWithUrl:requestURL method:method];
    //2、处理请求参数
    NSString *jsonString = [self dealParamToStringWithDict:params];
    //将对象设置到requestbody中<主要操作>
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    //3、进行网络请求
    [[self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {

    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {//网络请求成功
            NSLog(@"登陆或验证码success = %@",responseObject);
            success(responseObject);
        } else {//网络请求失败
            NSLog(@"登陆或验证码fail = %@",error);
            failure(error);
        }
    }] resume];
}

#pragma mark - 发起网络请求(参数在param)
- (void)sendRequestWithMethod:(HTTPMethod)method
                     WithPath:(NSString *)path
                   WithParams:(NSDictionary*)params
             WithSuccessBlock:(void(^)(NSDictionary *result))success
              WithFailurBlock:(void(^)(NSError *error))failure
{
    //添加来源字段
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] initWithDictionary:params];
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
        NSLog(@"task.currentRequest.URL-success = %@",task.currentRequest.URL);
        NSLog(@"success----responseObject = %@",responseObject);
        NSLog(@"allHTTPHeaderFields = %@",task.currentRequest.allHTTPHeaderFields);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"task.currentRequest.URL-error = %@",task.currentRequest.URL);
        NSLog(@"error= %@",error);
        failure(error);
    }];
}

#pragma mark - 发起post请求
- (void)sendPostRequestWithPath:(NSString *)path
                    WithParams:(NSDictionary*)params
              WithSuccessBlock:(void(^)(NSDictionary *result))success
               WithFailurBlock:(void(^)(NSError *error))failure
{
    NSLog(@"paramsparamsparams = %@",params);
    [self POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"task.currentRequest.URL-success = %@",task.currentRequest.URL);
        NSLog(@"success----responseObject = %@",responseObject);
        NSLog(@"allHTTPHeaderFields = %@",task.currentRequest.allHTTPHeaderFields);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"task.currentRequest.URL-error = %@",task.currentRequest.URL);
        NSLog(@"error= %@",error);
        failure(error);
    }];
}

#pragma mark - 设置request
- (NSMutableURLRequest *)dealURLRequestWithUrl:(NSString *)url method:(HTTPMethod) method{
    //1、请求方法
    NSString *requestMethod;
    if (method == HTTPMethodGet) {
        requestMethod = @"GET";
    }else if (method == HTTPMethodPost){
        requestMethod = @"POST";
    }else{
        requestMethod = @"GET";
    }
    //2、请求request
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:requestMethod URLString:url parameters:nil error:nil];
    //设置超时时长
    request.timeoutInterval= SPCTimeoutInterval;
    //设置上传数据type
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //设置接受数据type
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}

#pragma mark - 处理参数
- (NSString *)dealParamToStringWithDict:(NSDictionary *)params{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
