//
//  WWNetWorkManager.m
//  HYBiPad
//
//  Created by 杨世川 on 2018/7/6.
//  Copyright © 2018年 winwayworld. All rights reserved.
//

#import "WWNetWorkManager.h"
//网络请求超时时间
static float WWTimeoutInterval = 30.0;

@implementation WWNetWorkManager

//单例
+ (instancetype)sharedManager
{
    static WWNetWorkManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:WWBaseUrl]];
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
        case HTTPMethodUpLoad:
        {
            [self sendUpLoadRequestWithPath:path WithParams:resultParams WithSuccessBlock:success WithFailurBlock:failure];
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

#pragma mark - 上传图片
- (void)sendUpLoadRequestWithPath:(NSString *)path
                     WithParams:(NSDictionary*)params
               WithSuccessBlock:(void(^)(NSDictionary *result))success
                WithFailurBlock:(void(^)(NSError *error))failure
{
    
    NSString *get_url = [NSString stringWithFormat:@"/app?op=Upload"];
    NSString *compliteUrl = [NSString stringWithFormat:@"%@%@&_userid=%d&_password=%@",WWImageFileUrl,get_url,[WWUserEntity sharedInstance].userId,[WWUserEntity sharedInstance].password];
    NSLog(@"%@",compliteUrl);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20000;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    [manager POST:compliteUrl parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 可以在上传时使用当前的系统时间作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", dateString];
        [formData appendPartWithFileData:params[@"imageData"] name:@"filename" fileName:fileName mimeType:@"image/jpeg"];
        
        NSLog(@"%@",formData);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度 ---- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * jsonData = [responseObject mj_keyValues];
        NSLog(@"上传图片返回的数据 ----- %@",jsonData);
        success(jsonData);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    
//    self.requestSerializer.timeoutInterval = 20000;
//    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
//
//    [self POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//        // 可以在上传时使用当前的系统时间作为文件名
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        // 设置时间格式
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *dateString = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", dateString];
//        [formData appendPartWithFileData:params[@"imageData"] name:@"filename" fileName:fileName mimeType:@"image/jpeg"];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//            NSLog(@"上传进度 ---- %@",uploadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary * jsonData = [responseObject mj_keyValues];
//        NSLog(@"上传图片返回的数据 ----- %@",jsonData);
//        success(jsonData);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
}


@end
