//
//  ProductType.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-18.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"

@interface ProductType : JSONModel
@property (nonatomic, assign) NSUInteger     amount;
@property (nonatomic, assign) NSUInteger     typeId;
@property (nonatomic, assign) NSUInteger     parentid;
@property (nonatomic, assign) NSUInteger     orders;
@property (nonatomic, assign) NSUInteger     solutionid;
@property (nonatomic, copy)   NSString       *typeName;
@property (nonatomic, strong) NSMutableArray *listPro_ProType;
@end
