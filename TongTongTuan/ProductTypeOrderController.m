//
//  ProductTypeOrderController.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ProductTypeOrderController.h"
#import "ProductSpecificationCell.h"

@interface ProductTypeOrderController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UIView *containerView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 收货地址
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipCodeLabel;

// 送货时间
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

// 配送说明
@property (weak, nonatomic) IBOutlet UIView *tipsLable;

// 随时退款，过期退款
@property (weak, nonatomic) IBOutlet UIImageView *refundImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *refundImageView2;

@property (assign, nonatomic) NSInteger numberOfRow;
@end

@implementation ProductTypeOrderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"商品类";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductSpecificationCell" bundle:nil]
         forCellReuseIdentifier:@"ProductSpecificationCell"];
}

- (void)setScrollViewContentSize:(UIScrollView *)scrollView
{
    CGRect contentSize = CGRectZero;
    for (UIView *subview in scrollView.subviews) {
        contentSize = CGRectUnion(contentSize, subview.frame);
    }
    scrollView.contentSize = contentSize.size;
}

- (void)setProduct:(Product *)product
{
    _product = product;
    self.numberOfRow = 4 + product.prospecs.count; // 4为必须出现的表单元数量,包括单价，小计，运费，总价
    [self.tableView reloadData];
    
    // 延迟执行，否则有可能出现在tableView没有完成加载列表之前就开始进行界面的布局,导致界面布局不正确(因为此时还不知道
    // tableView的高度)
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self layoutUI];
    });
}

- (void)layoutUI
{
    CGRect f1 = self.containerView1.frame;
    CGSize size = self.tableView.contentSize;
    f1.size.height = size.height + 29;  // 29为tableView顶部与容器1的间距
    
    CGRect f2 = self.containerView2.frame;
    f2.origin.y = f1.origin.y + f1.size.height + 16; // 16为容器1和容器2之前的间距
    
    self.containerView1.frame = f1;
    self.containerView2.frame = f2;
    
    [self setScrollViewContentSize:(UIScrollView *)self.view];
}

// 选择收货日期
- (IBAction)selectReceiptDateLabel:(id)sender
{
    
}

// 提交订单
- (IBAction)submitOrder:(id)sender
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if(indexPath.row > 0 && indexPath.row < self.numberOfRow - 3){
        ProductSpecificationCell *pcell = [self.tableView dequeueReusableCellWithIdentifier:@"ProductSpecificationCell"];
        cell = pcell;
    }else{
        static NSString *identifier = @"cellIdentifier";
        cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.row == 0){
            cell.textLabel.text = @"单价:";
            cell.detailTextLabel.text = [NSString stringWithFormat:@""];
        }else if(indexPath.row == self.numberOfRow - 3){
            cell.textLabel.text = @"小计:";
        }else if(indexPath.row == self.numberOfRow - 2){
            cell.textLabel.text = @"运费:";
        }else if(indexPath.row == self.numberOfRow - 1){  
            cell.textLabel.text = @"总价:";
        }
    }
    
    return cell;
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setPhoneNumberLabel:nil];
    [self setAddressLabel:nil];
    [self setZipCodeLabel:nil];
    [self setDateLabel:nil];
    [self setTipsLable:nil];
    [self setRefundImageView1:nil];
    [self setRefundImageView2:nil];
    [self setTableView:nil];
    [self setContainerView1:nil];
    [self setContainerView2:nil];
    [super viewDidUnload];
}
@end
