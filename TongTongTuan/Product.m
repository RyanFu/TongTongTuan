//
//  Product.m
//  TongTongTuan
//
//  Created by xcode on 13-7-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "Product.h"
#import "Comment.h"
#import "ProductSpecification.h"

@implementation Product
- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.pid = ((NSNumber *)value).integerValue;
        
    }else if([key isEqualToString:@"comment_score"]){ // 评论列表
        self.commentList = [NSMutableArray new];
        NSArray *array = (NSArray *)value;
        for(NSMutableDictionary *dic in array){
            [self.commentList addObject:[[Comment alloc] initWithDictionary:dic]];
        }
        
    }else if([key isEqualToString:@"prospecs"]){  // 产品规格
        self.prospecs = [NSMutableArray new];
        NSArray *array = (NSArray *)value;
        for(NSMutableDictionary *dic in array){
            [self.prospecs addObject:[[ProductSpecification alloc] initWithDictionary:dic]];
        }
        
    }else if([key isEqualToString:@"postage"]){
        self.postage = [[Postage alloc] initWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}

- (void)copyDetailInfoToSelf:(Product *)p
{
    self.isLoadedDetail = YES;
    
    self.promemo = [p.promemo copy];
    self.buyprompt = [p.buyprompt copy];
    self.shopname  = [p.shopname copy];
    self.address = [p.address copy];
    self.commentList = [p.commentList copy];
    self.prospecs = [p.prospecs copy];
    self.distance = p.distance;
    self.pro_model = p.pro_model;
    self.pay_max = p.pay_max;
}
@end
