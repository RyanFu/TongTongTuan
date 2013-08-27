//
//  Order.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-23.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "Order.h"

@implementation Order

- (void) setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.oId = ((NSNumber *)value).integerValue;
        
    }else if([key isEqualToString:@"logistics"]){
        self.logistics = [[Logistics alloc] initWithDictionary:value];
        
    }else if([key isEqualToString:@"orderdetails"]){
        self.orderdetails = [NSMutableArray array];
        NSArray *array = (NSArray *)value;
        for(NSMutableDictionary *dic in array){
            [self.orderdetails addObject:[[OrderDetail alloc] initWithDictionary:dic]];
        }
        
    }else if([key isEqualToString:@"orderverifycode"]){
        self.orderverifycode = [NSMutableArray array];
        NSArray *array = (NSArray *)value;
        for(NSMutableDictionary *dic in array){
            [self.orderverifycode addObject:[[OrderVerifyCode alloc] initWithDictionary:dic]];
        }
        
    }else{
        [super setValue:value forKey:key];
    }
}

@end
