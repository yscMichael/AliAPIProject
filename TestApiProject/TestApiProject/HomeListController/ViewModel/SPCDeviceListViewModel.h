//
//  SPCDeviceListViewModel.h
//  TestApiProject
//
//  Created by yangshichuan on 2019/11/26.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPCDeviceListViewModel : NSObject
// 获取用户绑定的设备列表
- (void)loadUserDeviceListWithCompletionHandler:(void (^)(NSArray *list, NSError *error))completionHandler;
@end

NS_ASSUME_NONNULL_END
