//
//  UserInfoValidator.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-27.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "UserInfoValidator.h"

@implementation UserInfoValidator

BOOL valid(NSString *validateObj, NSString *regEx)
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES%@", regEx] evaluateWithObject:validateObj];
}


+ (BOOL)isValidMobileNumber:(NSString*)mobileNum
{
    /* 手机号
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /* 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /* 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /* 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /* 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    //NSString *PHS    = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    /* 贵州省座机
     区号	地名
     0851	贵阳,清镇,修文,息烽,开阳
     0852	遵义,习水,道真,桐梓,赤水,绥阳,正安,湄潭,凤冈,务川,遵义县,余庆,仁怀
     0853	安顺,紫云,平坝,关岭,镇宁,普定
     0854	都匀,福泉,瓮安,三都,荔波,独山,平塘,罗甸,惠水,龙里,贵定,长顺
     0855	凯里,黄平,施秉,镇远,岑巩,三穗,天柱,锦屏,黎平,从江,榕江,雷山,丹寨,麻江,台江,剑河
     0856	铜仁,玉屏,江口,石阡,思南,印江,德江,沿河,松桃,万山
     0857	毕节,威宁,赫章,纳雍,黔西,大方,金沙,织金
     0858	六盘水,六枝,盘县,水城
     0859	兴义,晴隆,册亨,望谟,安龙,兴仁,贞丰,普安
     */
    NSString *GZ  = @"^085[1-9]\\d{7,8}$";
    
    return (   valid(mobileNum, MOBILE)
            || valid(mobileNum, CM)
            || valid(mobileNum, CU)
            || valid(mobileNum, CT)
            || valid(mobileNum, GZ));
}


+ (BOOL)isValidEmail:(NSString *)email
{
    return valid(email, @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}");
}


+  (BOOL)isValidZipCode:(NSString *)zipCode
{
    return valid(zipCode, @"[1-9]\\d{5}(?!\\d)");
}


+ (BOOL)isDecimal:(NSString *)string
{
    BOOL aBool = valid(string, @"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$");
    if(aBool){
        char c = [string characterAtIndex:0];
        return c == '.' ?  NO : YES;
    }
    return aBool;
}
@end
