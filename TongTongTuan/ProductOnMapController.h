//
//  ProductOnMapController.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

// 在地图显示商品信息(紧显示本地生活服务类)
@interface ProductOnMapController : UIViewController

// 设置这个属性将自动更新地图上面的产品信息
@property (nonatomic, strong) NSMutableArray *productListArray;
@end
