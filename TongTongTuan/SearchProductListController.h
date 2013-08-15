//
//  SearchProductListController.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-13.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "BaseController.h"
#import "ProductListView.h"

// 呈现产品搜索的结果
@interface SearchProductListController : BaseController
@property (nonatomic, strong) ProductListView *productListView;
@end
