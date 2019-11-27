//
//  SPCCommonInitTool.h
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/27.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPCCommonInitTool : NSObject
//单例
+ (instancetype)sharedManager;

//API通道
//初始化IMSConfiguration
- (void)initIMSConfiguration;

//账号及用户SDK
//初始化ALBBOpenAccountSDK
- (void)initALBBOpenAccountSDK;

@end

NS_ASSUME_NONNULL_END
