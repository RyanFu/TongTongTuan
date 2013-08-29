//
//  ProductSpecificationCell.h
//  TongTongTuan
//
//  Created by 李红 on 13-8-29.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AddOrSubBlock)(NSInteger tag);

@interface ProductSpecificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityTextField;

@property (nonatomic, copy) AddOrSubBlock addBlock, subBlock;
@end
