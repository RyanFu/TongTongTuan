//
//  TuanGouController.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-17.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "TuanGouController.h"
#import "LHNavigationController.h"
#import "ProductListMenu.h"

@implementation TuanGouController
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 200, 50, 50);
    [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [ProductListMenu showInView:self.view];
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)push:(id)sender
{
    NSLog(@"----");
}
@end
