//
//  FXKeychain+User.m
//  TongTongTuan
//
//  Created by 李红 on 13+8+20.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "FXKeychain+User.h"

static const NSString *kAccount = @"UserAccount",
                      *kPassword = @"UserPassword";

@implementation FXKeychain (User)

+ (NSString *)userAccount
{
    return [[FXKeychain defaultKeychain] objectForKey:kAccount];
}

+ (NSString *)userPassword
{
    return [[FXKeychain defaultKeychain] objectForKey:kPassword];
}

+ (BOOL)isUserLogin
{
    return [FXKeychain userAccount] ? YES : NO;
}

+ (void)userLogout
{
    [[FXKeychain defaultKeychain] removeObjectForKey:kAccount];
    [[FXKeychain defaultKeychain] removeObjectForKey:kPassword];
}

+ (void)saveUserAccount:(NSString *)account andPassword:(NSString *)password
{
    [[FXKeychain defaultKeychain] setObject:account forKey:kAccount];
    [[FXKeychain defaultKeychain] setObject:password forKey:kPassword];
}

@end
