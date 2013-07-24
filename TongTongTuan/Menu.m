//
//  Menu.m
//  TongTongTuan
//
//  Created by xcode on 13-7-19.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "Menu.h"

@implementation Menu
- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.menuId = ((NSNumber *)value).unsignedIntegerValue;
    }  
    else
    {
        [super setValue:value forKey:key];
    }
}
@end
