//
//  Order.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-23.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"
#import "Logistics.h"
#import "OrderDetail.h"
#import "OrderVerifyCode.h"

// 订单实体
@interface Order : JSONModel
@property (nonatomic, copy)     NSString *areacode;         // 地区代码
@property (nonatomic, copy)     NSString *createdate;       // 订单创建时间
@property (nonatomic, copy)     NSString *createdatestr;    // 订单创建时间字符串格式
@property (nonatomic, assign)   NSInteger fromto;           // 订单来源 1网站 2客户端 3WAP
@property (nonatomic, assign)   NSInteger oId;              // 订单ID
@property (nonatomic, copy)     Logistics *logistics;       // 物流信息List<OrderDetail>
@property (nonatomic, copy)     NSMutableArray   *orderdetails;    // 订单商品信息
@property (nonatomic, copy)     NSString  *orderno;              // 订单号 yyMMdd0000-123，（0000）流水号，123随机数
@property (nonatomic, copy)     NSMutableArray   *orderverifycode; // 订单验证码信息(优惠券)List<OrderVerifyCode>
@property (nonatomic, copy)     NSString  *origqid;         // 交易流水号
@property (nonatomic, assign)   CGFloat summoney;           // 订单金额合计
@property (nonatomic, assign)   NSInteger sys_customer_id;  // 用户ID
// 状态 10待支付 20待发货 30待收货确认40待评论 50结单 60申请退款 70已退款 90删除
@property (nonatomic, assign)   NSInteger status;

@end
