//
//  Logistics.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-23.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"

// 订单物流
@interface Logistics : JSONModel
@property (nonatomic, assign) NSInteger lId;   //物流信息ID
@property (nonatomic, assign) NSInteger ord_order_id;
@property (nonatomic, copy) NSString *fullAddress;    //完整收货地址
@property (nonatomic, copy) NSString *recive_address; //收货地址
@property (nonatomic, copy) NSString *recive_province;
@property (nonatomic, copy) NSString *recive_city;
@property (nonatomic, copy) NSString *recive_district;
@property (nonatomic, copy) NSString *recive_phone; // 收货电话
@property (nonatomic, copy) NSString *recive_man;   // 收货人
//收货方式 1只工作日送货(双休日、假日不用送，写字楼/商用地址客户请选择)
//2只双休日、假日送货(工作日不用送)
//3学校地址/地址白天没人，请尽量安排其它时间送货 (特别安排可能会超出预计送货天数)
//4工作日、双休日与假日均可送货
@property (nonatomic, assign) NSInteger *recive_mode;

@end
