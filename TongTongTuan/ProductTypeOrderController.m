//
//  ProductTypeOrderController.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-26.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ProductTypeOrderController.h"
#import "ProductSpecificationCell.h"
#import "ProductSpecification.h"
#import "UserInfo.h"
#import "FXKeychain+User.h"
#import "AppDelegate.h"
#import "SIAlertView.h"

AddOrSubBlock addBlock, subBlock;

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
@property (assign, nonatomic) NSInteger sum; //购买商品总数
@property (strong, nonatomic) UserInfo *userInfo;
@end

@implementation ProductTypeOrderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"商品类";
        self.sum = 0;
        
        // 增加购买商品数量
        addBlock = ^(ProductSpecificationCell *cell){
            // 购买商品总数大于此商品限够个数
            // 注:pay_max为0代表不限制购买数量
            if(self.product.pay_max != 0 && self.sum >= self.product.pay_max){ 
                NSString *message = [NSString stringWithFormat:@"此商品最多只允许购买%d个", self.sum];
                [SIAlertView showWithMessage:message text1:@"关闭" okBlock:^{}];
                return;
            }
            
            NSInteger i =  cell.quantityTextField.text.integerValue;
            ProductSpecification *ps = self.product.prospecs[cell.tag];
            if(i < ps.storeqty){ // 每个规格商品的购买数必须小于此规格商品的库存数
                i++;
                self.sum++;
                cell.quantityTextField.text = [NSString stringWithFormat:@"%d",i];
                
                [self.tableView reloadData];
            }else{
                NSString *message = [NSString stringWithFormat:@"此规格的产品最多只能购买%d个",ps.storeqty];
                [SIAlertView showWithMessage:message text1:@"关闭" okBlock:^{}];
            }
        };
        
        // 减少购买商品数量
        subBlock = ^(ProductSpecificationCell *cell){
            if(self.sum == 1){ 
                [SIAlertView showWithMessage:@"亲，至少必须选择一个商品🎁" text1:@"关闭" okBlock:^{}];
                return;
            }
            
            NSInteger i =  cell.quantityTextField.text.integerValue;
            if(i > 0){
                i--;
                self.sum--;
                cell.quantityTextField.text = [NSString stringWithFormat:@"%d",i];
                cell.leftButton.enabled = YES;
                if(i == 0){
                    cell.leftButton.enabled = NO;
                }
                
                [self.tableView reloadData];
            }
        };
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductSpecificationCell" bundle:nil]
         forCellReuseIdentifier:@"ProductSpecificationCell"];
    
    NSAssert([FXKeychain isUserLogin], @"未登陆，必须先登陆");
    self.userInfo = GetUserInfo();
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
        ProductSpecificationCell *pcell = [self.tableView
                                           dequeueReusableCellWithIdentifier:@"ProductSpecificationCell"];
        pcell.addBlock = addBlock;
        pcell.subBlock = subBlock;
        
        NSInteger i = indexPath.row - 1;
        ProductSpecification *ps = self.product.prospecs[i];
        pcell.tag = i;  // 在addBlock和subBlock里面将使用此值来访问self.product.prospecs[i];
        pcell.nameLabel.text = ps.specname;
        
        NSInteger q = pcell.quantityTextField.text.integerValue;
        pcell.quantityTextField.text = [NSString stringWithFormat:@"%d", q];
        pcell.leftButton.enabled = (q == 0 ? NO : YES);
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
        
        CGFloat price;
        if(self.userInfo.usertype > 1){ // 会员
            price = self.product.price_member;
        }else{  // 普通会员(注册了，但没交钱开通的账户)
            price = self.product.price_nomember;
        }
        
        if(indexPath.row == 0){
            cell.textLabel.text = @"单价:";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.1f",price];
        }else if(indexPath.row == self.numberOfRow - 3){
            cell.textLabel.text = @"小计";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.1f", self.sum * price];
        }else if(indexPath.row == self.numberOfRow - 2){
            cell.textLabel.text = @"运费:";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.1f",self.product.postage.postage];
        }else if(indexPath.row == self.numberOfRow - 1){
            // 总价=购买商品数量 x 单价 - 邮费
            CGFloat p = (self.sum * price) - self.product.postage.postage;
            cell.textLabel.text = @"总价";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.1f", p];
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
