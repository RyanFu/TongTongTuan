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
@property (nonatomic, assign) CGFloat      price;           // 原价
@property (nonatomic, assign) CGFloat      price_member;    // 包月会员价
@property (nonatomic, assign) CGFloat      price_nomember;  // 非会员价
@property (nonatomic, assign) CGFloat      price_settle;    // 结算价
@property (nonatomic, assign) NSInteger    pro_model;       // 商品类型 1产品类 2服务类 3优惠券
@property (nonatomic, assign) NSInteger    pro_protype_id;
@property (nonatomic, assign) NSInteger    pro_team_id;
@property (nonatomic, copy)   NSString     *procode;        // 商品编号 商品编号 yyMMddHHmmss-nnn
@property (nonatomic, copy)   NSString     *prodescription;
@property (nonatomic, copy)   NSString     *promemo;
@property (nonatomic, copy)   NSString     *proname;        // 商品名称
@property (nonatomic, copy)   NSString     *propic;
@property (nonatomic, copy)   NSString     *protitle;
@property (nonatomic, assign) NSInteger    refund_anytime;  // 随时退款 0不支持 1支持
@property (nonatomic, assign) NSInteger    refund_overtime; // 过期退款 0不支持 1支持
@property (nonatomic, assign) NSInteger    reservation;
@property (nonatomic, copy)   NSString     *smscontent;
@property (nonatomic, assign) NSInteger    sortid;
@property (nonatomic, assign) NSInteger    status;
@property (nonatomic, assign) NSInteger    sys_coinfo_id;
@property (nonatomic, assign) NSInteger    sys_solution_id;
@property (nonatomic, copy)   NSString     *up_date;
@property (nonatomic, copy)   NSString     *up_datestr;     // 上架时间（字符串类型）
@property (nonatomic, assign) NSInteger    virtualbuy;      // 虚拟购买数（注水
@property (nonatomic, copy)   NSString     *linkphone;
@property (nonatomic, copy)   NSString     *shopname;
@property (nonatomic, assign) CGFloat      distance;
@property (nonatomic, assign) CGFloat      score_avg;       // 商品评分平均分
@property (nonatomic, copy)   NSString     *address;
@property (nonatomic, copy)   NSString     *textimgurl;
@property (nonatomic, assign) BOOL         isLoadedDetail;  // 是否载入过产品详情,默认No没有载入，YES载入过.
@property (nonatomic, strong) NSMutableArray *commentList;  // 评论列表
@property (nonatomic, strong) NSMutableArray *prospecs;     // 产品规格

- (void)copyDetailInfoToSelf:(Product *)p;
@end
