//
//  JSONModel.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-17.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"

@implementation JSONModel
-(id) initWithDictionary:(NSMutableDictionary*) jsonObject
{
    if((self = [super init]))
    {
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
}

#pragma mark - Key Value Coding

- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"%@：获取值出错，未定义的键：%@", NSStringFromClass([self class]), key);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@:%@", key, value);
    NSLog(@"%@：设置值出错，未定义的键：%@", NSStringFromClass([self class]), key);
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    @try {
        [super setValue:value forKey:key];
    }
    @catch (NSException *exception) {
        NSLog(@"---------------------------\n| 设置值发生异常:%@ |---------------------------\n", [exception reason]);
    }
    @finally {
        
    }
}

#pragma mark - NSCoding

-(BOOL) allowsKeyedCoding
{
	return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [super init];
}

#pragma mark - NSCopying, NSMutableCopying

- (id)copyWithZone:(NSZone *)zone
{
    return  [[JSONModel allocWithZone:zone] init];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return  [[JSONModel allocWithZone:zone] init];
}

@end
