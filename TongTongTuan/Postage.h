//
//  Postage.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-30.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"
#import "Logistics.h"

// 邮费实体
@interface Postage : JSONModel
@property (nonatomic, assign) NSInteger pid;                // ID
@property (nonatomic, strong) Logistics *logisticsco;       // 物流企业信息
@property (nonatomic, assign) NSInteger minbuyqty;          // 购买几件包邮,为0代表不限
@property (nonatomic, assign) CGFloat   postage;            // 每件邮费,0为包邮
@property (nonatomic, assign) NSInteger pro_product_id;     // 产品ID
@property (nonatomic, assign) NSInteger sys_logisticsco_id; // 企业物流ID
@end
