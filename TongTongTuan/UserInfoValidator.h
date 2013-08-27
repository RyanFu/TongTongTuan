//
//  UserInfoValidator.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-27.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoValidator : NSObject
+ (BOOL)isValidMobileNumber:(NSString*)mobileNum;
+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)isValidZipCode:(NSString *)zipCode;
@end
