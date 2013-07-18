//
//  ProductType.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-18.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ProductType.h"

@implementation ProductType
- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.typeId = ((NSNumber *)value).unsignedIntegerValue;
    }else if([key isEqualToString:@"typename"])
    {
        self.typeName = value;
    }else if([key isEqualToString:@"listPro_ProType"])
    {
        NSArray *subTypeJsonArray = (NSArray *)value;
        if(subTypeJsonArray.count > 0)
        {
            NSMutableArray *subTypeArray = [NSMutableArray new];
            for(NSMutableDictionary *dic in subTypeJsonArray)
            {
                [subTypeArray addObject:[[ProductType alloc] initWithDictionary:dic]];
            }
            self.listPro_ProType = subTypeArray;
        }
    }
    else
    {
        [super setValue:value forKey:key];
    }
}
@end
