//
//  HomeListController.m
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/25.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "HomeListController.h"
#import "SPCDeviceListViewModel.h"

@interface HomeListController ()
// 获取用户列表
@property(nonatomic,strong) SPCDeviceListViewModel *listViewModel;

@end

@implementation HomeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页设备列表";
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
