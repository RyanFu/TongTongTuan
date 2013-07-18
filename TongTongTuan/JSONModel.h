//
//  JSONModel.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-17.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

// 每个模型类都应该继承此类以实现将JSON数据映射为一个对象
@interface JSONModel : NSObject <NSCoding, NSCopying, NSMutableCopying>

-(id) initWithDictionary:(NSMutableDictionary *) jsonObject;

@end
