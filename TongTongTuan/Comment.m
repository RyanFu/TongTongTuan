//
//  Comment.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-8-15.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "Comment.h"

@implementation Comment
- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.cid = ((NSNumber *)value).integerValue;
    }else{
        [super setValue:value forKey:key];
    }
}
@end
