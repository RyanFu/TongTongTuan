//
//  UserInfo.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"
#import "Logistics.h"

// 用户信息
@interface UserInfo : JSONModel
@property (nonatomic, assign) CGFloat account_balance;      // 账户余额，采用DES加密
@property (nonatomic, copy)   NSString *citycode;
@property (nonatomic, copy)   NSString *cityname;
@property (nonatomic, copy)   NSString *createdate;
@property (nonatomic, copy)   NSString *createdatestr;
@property (nonatomic, copy)   NSString *email;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy)   NSString *lastlogin;
@property (nonatomic, copy)   NSString *NickName;
@property (nonatomic, copy)   NSString *lastloginstr;
@property (nonatomic, assign) CGFloat memberpPoint;         // 会员积分
@property (nonatomic, copy)   NSString *msgmobileno;        // 随机密码获取手机号
@property (nonatomic, copy)   NSString *password;           // 用户密码，MD5加密结果
@property (nonatomic, copy)   NSString *phoneno;            // 手机号码，只能是手机号
@property (nonatomic, copy)   NSString *provincecode;
@property (nonatomic, copy)   NSString *provincename;
@property (nonatomic, assign) NSString *sessionid;          // SessionID
@property (nonatomic, assign) NSInteger status;             // 状态 0待激活 1激活状态 2停用
@property (nonatomic, copy)   NSString *username;           // 客户姓名
@property (nonatomic, assign) NSInteger usertype;           // 1普通会员 2SP包月会员 3支付宝充值会员
@property (nonatomic, assign) NSInteger order_coupon;       // 优惠卷订单数
@property (nonatomic, assign) NSInteger order_lottery;      // 抽奖订单数
@property (nonatomic, assign) NSInteger order_payment_no;   // 待付款订单数
@property (nonatomic, assign) NSInteger order_payment_ok;   // 已付款订单数
@property (nonatomic, assign) NSInteger vouchersnum;        // 待金券数
@property (nonatomic, assign) NSInteger memberpoint;        // 会员积分
@property (nonatomic, assign) NSInteger collectionnum;      // 收藏商品数量
@property (nonatomic, strong) Logistics *defaultlogistics;  // 默认收货地址
@end
