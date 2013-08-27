//
//  ProductSpecification.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-23.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ProductSpecification.h"

@implementation ProductSpecification
- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.psId = ((NSNumber *)value).integerValue;
    }else{
        [super setValue:value forKey:key];
    }
}
@end
