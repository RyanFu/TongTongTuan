//
//  UserLoginInfo.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"
#import "UserInfo.h"

// 作为用户登陆的返回值
@interface UserLoginInfo : JSONModel
@property (nonatomic, strong)   UserInfo *CustomerInfo;   // 遇到这C#程序员写服务器 真J8蛋疼！！
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, assign) BOOL result;
@end
