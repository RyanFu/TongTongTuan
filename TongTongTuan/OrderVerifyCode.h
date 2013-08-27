//
//  OrderVerifyCode.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"

@interface OrderVerifyCode : JSONModel
@property (nonatomic, copy) NSString *checkoverdate;
@property (nonatomic, copy) NSString *checkoverdatestr;  // 订单创建时间字符串格式
@property (nonatomic, copy) NSString *createdate;
@property (nonatomic, copy) NSString *createdatestr;      // 订单创建时间字符串格式
@property (nonatomic, assign) NSInteger vId;
@property (nonatomic, assign) NSInteger ord_order_id;     // 订单ID
@property (nonatomic, assign) NSInteger status;           // 状态 0未使用 1已使用 2过期
@property (nonatomic, assign) NSInteger verificationcode; // 验证码
@end
