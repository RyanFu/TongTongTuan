//
//  OrderInfoModel.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"
#import "Order.h"

// 作为提交订单接口的返回值
@interface OrderInfoModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) Order *orderinfo;
@property (nonatomic, assign) BOOL result;
@end
