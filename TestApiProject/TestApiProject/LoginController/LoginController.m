//
//  LoginController.m
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/25.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "LoginController.h"
#import "HomeListController.h"

//获取验证码
NSString *const SPCGetVerificationCode = @"/api/skyworth-northbound/users/captcha";
//登陆
NSString *const SPCLogin = @"/api/skyworth-northbound/users/skyworthdigitallogin";

@interface LoginController ()
//输入验证码
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    NSLog(@"当前是登陆界面");
}

#pragma mark - 点击登陆按钮
- (IBAction)clickButton:(UIButton *)sender {
    
    NSDictionary *tempDict = @{
        @"phone":@"19924535784"
    };
    [[SPCNetWorkManager sharedManager] startRequestWithUrl:SPCGetVerificationCode method:HTTPMethodPost params:tempDict withSuccessBlock:^(NSDictionary *result) {
        
    } withFailurBlock:^(NSError *error) {
        
    }];
}

#pragma makr - 点击登陆按钮
- (IBAction)clickLoginButton:(UIButton *)sender {
    //登陆
    NSDictionary *tempDict = @{
        @"grant_type": @"password",
        @"scope": @"all",
        @"salt": @"",
        @"mobile": @"19924535784",
        @"username": @"19924535784",
        @"password": self.codeTextField.text
    };
    [[SPCNetWorkManager sharedManager] startRequestWithUrl:SPCLogin method:HTTPMethodPost params:tempDict withSuccessBlock:^(NSDictionary *result) {
        //如果codecode == 200,进入设备列表界面
        NSLog(@"resultresult = %@",result);
        if ([result[@"code"] intValue] == 200) {//进入设备列表界面
            HomeListController *homeCtrl = [[HomeListController alloc] init];
            [self.navigationController pushViewController: homeCtrl animated:YES];
        }else{//提示错误
            NSLog(@"tips= %@",result[@"msg"]);
        }
    } withFailurBlock:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}

@end

