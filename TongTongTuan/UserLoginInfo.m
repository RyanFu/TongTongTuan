//
//  UserLoginInfo.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "UserLoginInfo.h"

@implementation UserLoginInfo
- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"CustomerInfo"]){
        self.CustomerInfo = [[UserInfo alloc] initWithDictionary:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end
