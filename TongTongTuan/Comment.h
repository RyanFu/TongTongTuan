//
//  Comment.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-8-15.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"

@interface Comment : JSONModel
@property (nonatomic, copy) NSString
*username,*servicecc,*logisticscc,*realcc,*comment,*createdate,*createdatestr;

@property (nonatomic, assign) NSInteger
cid, ord_order_id, pro_product_id, score_service, score_logistics,score_real,counts,score_avg,cId;

@end
