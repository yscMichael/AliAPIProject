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

//单例
+ (instancetype)sharedManager;
//发起业务网络请求
- (void)sendRequestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(void(^)(NSDictionary *result))success
          WithFailurBlock:(void(^)(NSError *error))failure;

@end
