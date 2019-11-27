//
//  AppDelegate.m
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/25.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import <IMSApiClient/IMSConfiguration.h>
#import <IMSApiClient/IMSApiClient.h>
#import <IMSLog/IMSLog.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"launchOptionslaunchOptions = %@",launchOptions);
    self.window.backgroundColor = [UIColor whiteColor];
    [self initRootViewController];
    [self initFrameworkLaunchWithOptions:launchOptions];
    return YES;
}

#pragma mark - 初始化子控制器
- (void)initRootViewController
{
    LoginController *loginCtrl = [[LoginController alloc]init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];
}

#pragma mark - 初始化框架
- (void)initFrameworkLaunchWithOptions:(NSDictionary *)launchOptions{
    [[SPCCommonInitTool sharedManager] initAllSDK];
}

#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
