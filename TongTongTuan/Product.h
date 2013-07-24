//
//  Product.h
//  TongTongTuan
//
//  Created by xcode on 13-7-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "JSONModel.h"

@interface Product : JSONModel
@property (nonatomic, copy)   NSString     *area_city;
@property (nonatomic, copy)   NSString     *area_district;
@property (nonatomic, copy)   NSString     *area_province;
@property (nonatomic, copy)   NSString     *briefdescription;
@property (nonatomic, copy)   NSString     *buyprompt;
@property (nonatomic, copy)   NSString     *checkoverdate;
@property (nonatomic, copy)   NSString     *checkoverdatestr;
@property (nonatomic, assign) NSInteger    clicknum;
@property (nonatomic, copy)   NSString     *createdate;
@property (nonatomic, copy)   NSString     *createdatestr;
@property (nonatomic, copy)   NSString     *createuser;
@property (nonatomic, copy)   NSString     *down_date;
@property (nonatomic, copy)   NSString     *down_datestr;
@property (nonatomic, assign) NSInteger    pid;
@property (nonatomic, copy)   NSString     *keyword;
@property (nonatomic, assign) NSInteger    orderproqty;
@property (nonatomic, assign) NSInteger    pay_max;
@property (nonatomic, assign) NSInteger    pay_min;
@property (nonatomic, assign) NSInteger    paytype;
@property (nonatomic, assign) NSInteger    preferential;
@property (nonatomic, assign) CGFloat      price;
@property (nonatomic, assign) CGFloat      price_member;
@property (nonatomic, assign) CGFloat      price_nomember;
@property (nonatomic, assign) CGFloat      price_settle;
@property (nonatomic, assign) NSInteger    pro_model;
@property (nonatomic, assign) NSInteger    pro_protype_id;
@property (nonatomic, assign) NSInteger    pro_team_id;
@property (nonatomic, copy)   NSString     *procode;
@property (nonatomic, copy)   NSString     *prodescription;
@property (nonatomic, copy)   NSString     *promemo;
@property (nonatomic, copy)   NSString     *proname;
@property (nonatomic, copy)   NSString     *propic;
@property (nonatomic, copy)   NSString     *protitle;
@property (nonatomic, assign) NSInteger    refund_anytime;
@property (nonatomic, assign) NSInteger    refund_overtime;
@property (nonatomic, assign) NSInteger    reservation;
@property (nonatomic, copy)   NSString     *smscontent;
@property (nonatomic, assign) NSInteger    sortid;
@property (nonatomic, assign) NSInteger    status;
@property (nonatomic, assign) NSInteger    sys_coinfo_id;
@property (nonatomic, assign) NSInteger    sys_solution_id;
@property (nonatomic, copy)   NSString     *up_date;
@property (nonatomic, copy)   NSString     *up_datestr;
@property (nonatomic, assign) NSInteger    virtualbuy;
@end
