//
//  ServiceTypeOrderController.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ServiceTypeOrderController.h"
#import "Order.h"

@interface ServiceTypeOrderController ()
@property (nonatomic, strong) Order *order;
@end

@implementation ServiceTypeOrderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"服务类";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.order = [[Order alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
