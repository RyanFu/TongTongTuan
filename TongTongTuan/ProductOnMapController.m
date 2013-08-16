//
//  ProductOnMapController.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ProductOnMapController.h"

@implementation ProductOnMapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)goBackProductListView:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setProductListArray:(NSMutableArray *)productListArray
{
    _productListArray = productListArray;
}

@end
