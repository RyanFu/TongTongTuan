//
//  ProductListCell.m
//  TongTongTuan
//
//  Created by xcode on 13-7-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ProductListCell.h"
#import "Defines.h"

@implementation ProductListCell
- (void)updateView:(Product *)product
{
    self.nameLabel.text = product.protitle;
    self.introLabel.text = product.briefdescription;
    self.costPriceLabel.text = FLOAT_TO_STRING(product.price);
    self.NoVipLabel.text = FLOAT_TO_STRING(product.price_nomember);
    self.vipLabel.text = FLOAT_TO_STRING(product.price_member);
    self.numberOfBuyLable.text = [NSString stringWithFormat:@"%d人已购买", product.virtualbuy];
}
@end
