//
//  OrderVerifyCode.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "OrderVerifyCode.h"

@implementation OrderVerifyCode
- (void) setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.vId = ((NSNumber *)value).integerValue;
    }else{
        [super setValue:value forKey:key];
    }
}
@end
