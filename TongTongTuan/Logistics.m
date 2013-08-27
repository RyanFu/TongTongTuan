//
//  Logistics.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-23.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "Logistics.h"

@implementation Logistics

- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.lId = ((NSNumber *)value).integerValue;
    }else{
        [super setValue:value forKey:key];
    }
}

@end
