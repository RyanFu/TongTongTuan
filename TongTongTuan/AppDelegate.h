//
//  AppDelegate.h
//  TongTongTuan
//
//  Created by xcode on 13-7-15.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

#define GetUserInfo() [(AppDelegate *)([[UIApplication sharedApplication] delegate]) userInfo]
#define SetUserInfo(obj) [(AppDelegate *)([[UIApplication sharedApplication] delegate]) setUserInfo:obj]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *tuanGouController;

// 保存当前登陆的用户信息,通过GetUserInfo()和SetUserInfo()宏来对这个属性进行存取操作
@property (strong, nonatomic) UserInfo *userInfo;
@end
