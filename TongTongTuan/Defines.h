//
//  Defines.h
//  TongTongTuan
//
//  Created by xcode on 13-7-16.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#ifndef TongTongTuan_Defines_h
#define TongTongTuan_Defines_h

#define NAVIGATION_BAR_HEIGHT        44.0
#define TAB_BAR_HEIGHT               49.0
#define STATUS_BAR_HEIGHT            20.0
#define SCREEN_WIDTH                 320.0
#define SCREEN_HEIGHT ([[UIApplication sharedApplication] isStatusBarHidden] ? ([[UIScreen mainScreen] bounds].size.height) : ([[UIScreen mainScreen] bounds].size.height-20))

#define LHError(error) if (error) { \
NSLog(@"===发生错误:%@ (%d) ERROR: %@", \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
__LINE__, [error localizedDescription]); \
}

#define FLOAT_TO_STRING(f) [NSString stringWithFormat:@"%.2f",f]

#endif
