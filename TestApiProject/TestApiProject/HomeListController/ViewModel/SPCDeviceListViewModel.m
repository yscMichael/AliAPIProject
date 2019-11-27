//
//  SPCDeviceListViewModel.m
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/26.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "SPCDeviceListViewModel.h"

#import "IMSLifeLog.h"
#import <IMSApiClient/IMSApiClient.h>
#import <IMSAuthentication/IMSAuthentication.h>

NSString *ServerErrorDomain = @"ServerErrorDomain";
@interface SPCDeviceListViewModel ()

@end

@implementation SPCDeviceListViewModel
#pragma mark - 获取用户绑定的设备列表
- (void)loadUserDeviceListWithCompletionHandler:(void (^)(NSArray *list, NSError *error))completionHandler{
    NSString *path = @"/uc/listBindingByAccount";
    NSString *version = @"1.0.2";
    NSDictionary *params = @{
                             };
    
    [self requestWithPath:path
                  version:version
                   params:params
        completionHandler:^(NSError *error, id data) {
        NSLog(@"datadatadata = %@",data);
            if (completionHandler) {
                completionHandler([data objectForKey:@"data"], error);
            }
        }];
}

- (void)requestWithPath:(NSString *)path
                version:(NSString *)version
                 params:(NSDictionary *)params
      completionHandler:(void (^)(NSError *error, id data))completionHandler {
    IMSIoTRequestBuilder *builder = [[IMSIoTRequestBuilder alloc] initWithPath:path apiVersion:version params:params];
    [builder setScheme:@"https://"];
    IMSRequest *request = [[builder setAuthenticationType:IMSAuthenticationTypeIoT] build];
    
    IMSLifeLogVerbose(@"Request: %@", request);
    NSLog(@"Request: %@", request);
    [IMSRequestClient asyncSendRequest:request responseHandler:^(NSError *error, IMSResponse *response) {
        IMSLifeLogVerbose(@"Request: %@\nError:%@\nResponse: %d %@", request, error, response.code, response.data);
        NSLog(@"Request: %@\nError:%@\nResponse: %ld %@", request, error, (long)response.code, response.data);
        
        if (error == nil && response.code != 200) {
            NSDictionary *info = @{
                                   @"message" : response.message ? : @"",
                                   NSLocalizedDescriptionKey : response.localizedMsg ? : @"",
                                   };
            error = [NSError errorWithDomain:ServerErrorDomain code:response.code userInfo:info];
        }
        
        if (completionHandler) {
            completionHandler(error, response.data);
        }
    }];
}
@end
