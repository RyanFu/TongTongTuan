//
//  UserAccountSettingController.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-28.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "BaseController.h"

typedef void (^UserLogoutBlock)(void);

// 用户账户相关设置
@interface UserAccountSettingController : BaseController
@property (nonatomic, copy) UserLogoutBlock userLogoutBlock;
@end
