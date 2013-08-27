//
//  ProductSpecification.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-23.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"

//  产品规格
@interface ProductSpecification : JSONModel
@property (nonatomic, assign) NSUInteger psId;
@property (nonatomic, assign) NSUInteger pro_product_id; // 产品id
@property (nonatomic, assign) NSUInteger storeqty;       // 库存数
@property (nonatomic, copy) NSString *specname;          // 规格名
@property (nonatomic, copy) NSString *specdescription;   // 规格描述
@end
