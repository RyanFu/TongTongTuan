//
//  ServerReturnValue.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"

// 返回值模型
// 用于只需知道操作是成功或者失败的情况，比如用户登陆
@interface ServerReturnValue : JSONModel
@property (nonatomic, assign) BOOL result;
@property (nonatomic, copy) NSString *message;
@end
