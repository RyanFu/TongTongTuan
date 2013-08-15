//
//  SearchProductListController.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-13.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "SearchProductListController.h"

@interface SearchProductListController()
@end

@implementation SearchProductListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.productListView = [ProductListView showInView:self.view withFrame:self.view.bounds];
    self.productListView.navigationController = self.navigationController;
}

@end
