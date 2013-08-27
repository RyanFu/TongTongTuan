//
//  OrderDetail.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-23.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"

@interface OrderDetail : JSONModel
@property (nonatomic, assign) NSUInteger odId;
@property (nonatomic, assign) NSUInteger ord_order_id;  // 订单id
@property (nonatomic, assign) CGFloat postage;          // 邮费
@property (nonatomic, assign) CGFloat price;            // 单价
@property (nonatomic, assign) NSUInteger pro_spec_id;   // 产品规格ID
@property (nonatomic, assign) NSUInteger qty;           // 数量
@end
