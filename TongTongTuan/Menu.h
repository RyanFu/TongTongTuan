//
//  Menu.h
//  TongTongTuan
//
//  Created by xcode on 13-7-19.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"

@interface Menu : JSONModel
@property (nonatomic, assign) NSUInteger menuId;
@property (nonatomic, assign) NSUInteger parentid;
@property (nonatomic, assign) NSUInteger orders;
@property (nonatomic, assign) NSUInteger solutionid;
@property (nonatomic, copy)   NSString   *teamname;
@end
