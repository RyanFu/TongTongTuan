//
//  ResetUserPasswordController.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-28.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "BaseController.h"

typedef void (^ResetPasswordSuccessfulBlock)(void);

// 重置用户密码
@interface ResetUserPasswordController : BaseController
@property (nonatomic, copy) ResetPasswordSuccessfulBlock ResetPasswordSuccessfulBlock;
@end
