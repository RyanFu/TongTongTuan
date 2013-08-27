//
//  UserLoginController.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-27.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "BaseController.h"

typedef void (^UserLoginBlock)(BOOL flag);

@interface UserLoginController : BaseController
@property (nonatomic, copy) UserLoginBlock loginBlock;
@end
