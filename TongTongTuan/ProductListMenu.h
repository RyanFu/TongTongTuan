//
//  ProductListMenu.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-17.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTopMenuViewHeight 40.0
#define kButtonWidth (SCREEN_WIDTH / 3.0)
#define kSelfHeight  (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT -TAB_BAR_HEIGHT)
#define kDropViewHeight (kSelfHeight - kTopMenuViewHeight - 60.0)


@class Menu;
@class ProductType;
@protocol ProductListMenuDelegate;

@interface ProductListMenu : UIView
@property (nonatomic, weak) id<ProductListMenuDelegate> delegate;
+ (ProductListMenu *)showInView:(UIView *)superView;
@end


@protocol ProductListMenuDelegate <NSObject>
@required
- (void)productListTopMenu:(ProductListMenu *)topMenu didSelectedProductType:(ProductType *)type;
- (void)productListTopMenu:(ProductListMenu *)topMenu didSelectedMenu:(Menu *)menu;
- (void)productListTopMenu:(ProductListMenu *)topMenu didSelectedSortType:(NSInteger)index;
@end
