//
//  Product.m
//  TongTongTuan
//
//  Created by xcode on 13-7-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "Product.h"

@implementation Product
- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.pid = ((NSNumber *)value).integerValue;
    }else
    {
        [super setValue:value forKey:key];
    }
}
@end
