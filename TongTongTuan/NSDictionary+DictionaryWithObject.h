//
//  NSDictionary+DictionaryWithObject.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//


#import <Foundation/Foundation.h>

// 将一个对象的属性映射为一个Key-Value集合
@interface NSDictionary (DictionaryWithObject)
+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;
@end
