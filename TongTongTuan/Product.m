//
//  Product.m
//  TongTongTuan
//
//  Created by xcode on 13-7-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "Product.h"
#import "Comment.h"

@implementation Product
- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.pid = ((NSNumber *)value).integerValue;
        
    }else if([key isEqualToString:@"comment_score"]){
        self.commentList = [NSMutableArray new];
        NSArray *array = (NSArray *)value;
        for(NSMutableDictionary *dic in array){
            [self.commentList addObject:[[Comment alloc] initWithDictionary:dic]];
        }
        
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
    self.distance = [p.distance copy];
    
    self.commentList = [NSMutableArray new];
    [self.commentList addObjectsFromArray:p.commentList];
}
@end
