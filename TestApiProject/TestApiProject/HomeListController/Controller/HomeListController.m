//
//  HomeListController.m
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/25.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "HomeListController.h"
#import "SPCDeviceListViewModel.h"

#import <IMSApiClient/IMSApiClient.h>
#import <IMSAccount/IMSAccountService.h>
#import <IMSAuthentication/IMSAuthentication.h>
#import "IMSOpenAccount.h"

@interface HomeListController ()
// 获取用户列表
@property(nonatomic,strong) SPCDeviceListViewModel *listViewModel;

@end

@implementation HomeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页设备列表";
    [self initAuthentication];
}

#pragma mark - 进行身份认证
- (void)initAuthentication{
    //1、
    IMSAccountService *accountService = [IMSAccountService sharedService];
    // sessionProvider 需要开发者实现遵守IMSAccountProtocol协议的class 实例
    // accountService.sessionProvider = (id<IMSAccountProtocol>)sessionProvider;
    IMSOpenAccount *openAccount = [IMSOpenAccount sharedInstance];
    accountService.sessionProvider = openAccount;
    accountService.accountProvider = openAccount;
    
    //2、
    [IMSCredentialManager initWithAccountProtocol:accountService.sessionProvider];
    IMSIoTAuthentication *iotAuthDelegate = [[IMSIoTAuthentication alloc] initWithCredentialManager:IMSCredentialManager.sharedManager];
    [IMSRequestClient registerDelegate:iotAuthDelegate forAuthenticationType:IMSAuthenticationTypeIoT];
}

#pragma mark - 获取设备列表
- (IBAction)getDeviceList:(UIButton *)sender {
    [self.listViewModel loadUserDeviceListWithCompletionHandler:^(NSArray * _Nonnull list, NSError * _Nonnull error) {
        NSLog(@"listlistlist = %@",list);
        NSLog(@"errorerror = %@",error);
    }];
}

#pragma mark - Getter And Setter
- (SPCDeviceListViewModel *)listViewModel{
    if (!_listViewModel) {
        _listViewModel = [[SPCDeviceListViewModel alloc] init];
    }
    return _listViewModel;
}

@end
