//
//  UserInfoValidator.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-27.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoValidator : NSObject
// 验证电话号码合法性
+ (BOOL)isValidMobileNumber:(NSString*)mobileNum;

// 验证邮箱地址合法性
+ (BOOL)isValidEmail:(NSString *)email;

// 验证邮政编码合法性
+ (BOOL)isValidZipCode:(NSString *)zipCode;

// 验证一个字符串能否转为十进制数(包括小数,但不包括形如:.1234的数字)
+ (BOOL)isDecimal:(NSString *)string;
@end
