//
//  Postage.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-30.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "Postage.h"

@implementation Postage
- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.pid = ((NSNumber *)value).integerValue;
    }else{
        [super setValue:value forKey:key];
    }
}
@end
