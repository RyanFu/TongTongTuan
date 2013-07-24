//
//  ProductListCell.h
//  TongTongTuan
//
//  Created by xcode on 13-7-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBuyLable;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *costPriceTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *costPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoVipTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;

@property (weak, nonatomic) IBOutlet UIImageView *thumImageView;
@property (weak, nonatomic) IBOutlet UIImageView *separatorLineImageView;

- (void)updateView:(Product *)product;
@end
