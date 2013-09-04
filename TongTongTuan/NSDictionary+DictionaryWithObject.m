//
//  NSDictionary+DictionaryWithObject.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//


#import "NSDictionary+DictionaryWithObject.h"
#import "JSONModel.h"
#import <objc/runtime.h>

@implementation NSDictionary (DictionaryWithObject)
+(NSMutableDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *p = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(p[i])];
        id v = [obj valueForKey:key];
        if(v){
            if([[v class] isSubclassOfClass:[JSONModel class]]){
                v = [NSDictionary dictionaryWithPropertiesOfObject:v];
            }
            [dict setObject:v forKey:key];
        }else{ // .NET RESTFul框架要求字符串类型变量的值为NULL时，将一个空字符串付给此变量
            v = @"";
            [dict setObject:v forKey:key];
        }
    }
    
    free(p);
    return dict;
}
@end
