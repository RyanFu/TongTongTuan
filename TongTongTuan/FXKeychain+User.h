//
//  FXKeychain+User.h
//  TongTongTuan
//
//  Created by 李红 on 13+8+20.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "FXKeychain.h"

@interface FXKeychain (User)

+ (NSString *)userAccount;
+ (NSString *)userPassword;
+ (void)userLogout;
+ (BOOL)isUserLogin;
+ (void)saveUserAccount:(NSString *)account andPassword:(NSString *)password;
+ (void)updatePassword:(NSString *)password;
@end
