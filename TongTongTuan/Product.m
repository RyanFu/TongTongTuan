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
    }else if([key isEqualToString:@"comment_score"]){
        
    }else{
        [super setValue:value forKey:key];
    }
}

- (void)copyDetailInfoToSelf:(Product *)p
{
    self.isLoadedDetail = YES;
    
    self.promemo = [p.promemo copy];
    self.buyprompt = [p.buyprompt copy];
    
}
@end
