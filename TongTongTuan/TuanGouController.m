//
//  TuanGouController.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-17.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "TuanGouController.h"
#import "ProductListMenu.h"
#import "ProductListView.h"
#import "Defines.h"
#import "RESTFulEngine.h"
#import "Product.h"
#import "Menu.h"
#import "ProductType.h"
#import "CityListController.h"
#import "ProductOnMapController.h"
#import "SearchProductController.h"
#import "LocationManager.h"
#import "SIAlertView.h"
#import "Utilities.h"

#define kGuiYanCoordinate CLLocationCoordinate2DMake(26.62990760803223,106.7091751098633)

static CLLocationCoordinate2D currentCoordinate;
static const NSUInteger kDefaultDistance = 3000;
static const NSInteger kDefaultProductTypeId  = 0,
                       kDefaultProductGroupId = 1,
                       kDefaultProductSortId  = 1,
                       kDefaultPageIndex      = 0,
                       kDefaultPageSize       = 20;

static NSInteger currentProductTypeId = kDefaultProductTypeId,
                currentProductGroupId = kDefaultProductGroupId,
                 currentProductSortId = kDefaultProductSortId,
                 currentPageIndex     = kDefaultPageIndex;


@interface TuanGouController()<ProductListMenuDelegate,
                                ProductListViewDelegate,
                                CityListControllerDelegate,
                                LocationManagerDelegate>

@property (nonatomic, strong) ProductListView *productListView;
@property (nonatomic, strong) CityListController *cityListController;
@property (nonatomic, strong) UIView *navigationItemTitleView;
@property (nonatomic, strong) UIBarButtonItem *mapBarButtonItem, *searchProductBarButtonItem;
@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, strong) LocationManager *locationManager;
@end


@implementation TuanGouController
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 添加产品列表
    self.view.backgroundColor = [UIColor whiteColor];
    self.productListView = [ProductListView showInView:self.view withFrame:CGRectMake(0,kTopMenuViewHeight , SCREEN_WIDTH,SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-kTopMenuViewHeight-TAB_BAR_HEIGHT)];
    self.productListView.delegate = self;
    self.productListView.navigationController = self.navigationController;
    
    // 添加菜单视图
    [[ProductListMenu showInView:self.view] setDelegate:self];

    //在导航栏上添加地图，城市名称，搜索按钮
    self.navigationItem.titleView = self.navigationItemTitleView;
    self.navigationItem.leftBarButtonItem = self.mapBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.searchProductBarButtonItem;
    
    // 初始化城市列表控制器
    self.cityListController = [[CityListController alloc] initWithNibName:@"CityListController" bundle:nil];
    self.cityListController.delegate = self;
    
    // 如果保存有定位获得经纬度，那么用此经纬度来初始化currentCoordinate变量,否则默认的经纬度为贵阳地区的经纬度(通过kGuiYanCoordinate宏来初始化)
    CLLocationCoordinate2D coordinate = [Utilities getUserCoordinate];
    if(coordinate.latitude != 0){
        currentCoordinate = coordinate;
    }else{
        currentCoordinate = kGuiYanCoordinate;
    }
    
    //初始化定位管理器
    self.locationManager = [[LocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // 如果之前成功的定位(获取到了城市信息)，那么就开始加载产品列表。否则开始进行定位
    // 注意:这也就是说如果用户首次定位成功后，以后用户进入程序都不会再进行自定定位，除非用户显示的进行定位操作(譬如:获取周边的商品，
    // 这时需要重新存储城市名称信息和坐标信息)
    NSDictionary *dic = [Utilities getCurrentShowCity];
    if(dic)
    {
        [self.cityButton setTitle:dic[@"areaname"] forState:UIControlStateNormal];
        [self refreshProductList];
    }else{
        [self.locationManager startLocation];
    }
}


#pragma mark - Getter
- (UIBarButtonItem *)mapBarButtonItem
{
    if(_mapBarButtonItem)
    {
        return _mapBarButtonItem;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 100, NAVIGATION_BAR_HEIGHT)];
    [button setTitle:@"地图" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showProductListOnMap:) forControlEvents:UIControlEventTouchUpInside];
    _mapBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return _mapBarButtonItem;
}


- (UIBarButtonItem *)searchProductBarButtonItem
{
    if(_searchProductBarButtonItem)
    {
        return _searchProductBarButtonItem;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [button addTarget:self action:@selector(showSearchProductView:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    _searchProductBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return _searchProductBarButtonItem;
}


- (UIView *)navigationItemTitleView
{
    if(_navigationItemTitleView)
    {
        return _navigationItemTitleView;
    }
    
    _navigationItemTitleView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 220, 44)];
    [_navigationItemTitleView addSubview:self.cityButton];
    return _navigationItemTitleView;
}


- (UIButton *)cityButton
{
    if(_cityButton)
    {
        return _cityButton;
    }
    
    _cityButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 100, 44)];
    [_cityButton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [_cityButton setTitle:@"切换城市" forState:UIControlStateNormal];
    return _cityButton;
}


#pragma mark - ProductListMenuDelegate
- (void)productListTopMenu:(ProductListMenu *)topMenu didSelectedProductType:(ProductType *)type
{
    currentProductTypeId = type.typeId;
    [self refreshProductList];
}


- (void)productListTopMenu:(ProductListMenu *)topMenu didSelectedMenu:(Menu *)menu
{
    currentProductGroupId = menu.menuId;
    [self refreshProductList];
}


- (void)productListTopMenu:(ProductListMenu *)topMenu didSelectedSortType:(NSInteger)index
{
    currentProductSortId = index;
    if(currentProductSortId == 5) // 排序
    {
        
    }
    [self refreshProductList];
}


#pragma mark - ProductListViewDelegate
- (void)productListView:(ProductListView *)list refreshOnSuccess:(ArrayBlock)arrayBlock onError:(ErrorBlock)errorBlock
{
    [self refreshProductListOnSuccess:^(NSMutableArray *listOfModelBaseObjects) {
        arrayBlock(listOfModelBaseObjects);
    } onError:^(NSError *engineError) {
        errorBlock(engineError);
        [SIAlertView showWithMessage:@"刷新列表失败，再次下拉重试。" text1:@"关闭" okBlock:^{
        }];
    }];
}


- (void)productListView:(ProductListView *)list loadMoreOnSuccess:(ArrayBlock)arrayBlock onError:(ErrorBlock)errorBlock
{
        ++currentPageIndex;
}


#pragma mark - CityListController Delegate
- (void)cityListController:(CityListController *)controller cityDicationary:(NSDictionary *)cityDicationary
{
    [Utilities saveCurrentShowCity:cityDicationary];
    [self.cityButton setTitle:cityDicationary[@"areaname"] forState:UIControlStateNormal];
    [self refreshProductList];
}


#pragma mark - LocationManagerDelegate
- (void)locationManagerSuccess:(CLLocationCoordinate2D)coordinate cityDictionary:(NSDictionary *)cityDic name:(NSString *)name
{
    // 保存当前的定位坐标和定位到的城市信息
    [Utilities saveCurrentShowCity:cityDic];

    currentCoordinate = coordinate;
    [self.cityButton setTitle:cityDic[@"areaname"] forState:UIControlStateNormal];
    [self.cityListController setLocationCtiy:cityDic];
    [self refreshProductList];
}


// 如果定位失败，那么默认显示的城市名称是贵阳,商品为贵阳周边的商品
- (void)locationManagerFial
{
    NSDictionary *cityDic = @{@"areaname":@"贵阳市",@"areacode":@"520100"};
    [Utilities saveLocationCity:cityDic];
    [Utilities saveCurrentShowCity:cityDic];
    [Utilities saveUserCoordinate:kGuiYanCoordinate];

    [self.cityButton setTitle:cityDic[@"areaname"] forState:UIControlStateNormal];
    [self.cityListController setLocationCtiy:cityDic];
    [self refreshProductList];
}


#pragma mark - Action

- (void)refreshProductList
{
    [self refreshProductListOnSuccess:^(NSMutableArray *listOfModelBaseObjects) {
        if(listOfModelBaseObjects.count == 0){
            [SIAlertView showWithMessage:@"没有查询到商品信息" text1:@"关闭" okBlock:^{}];
        }
        [self.productListView refreshListhWithDataSource:listOfModelBaseObjects];

    } onError:^(NSError *engineError) {
        NSString *message = [NSString stringWithFormat:@"获取产品信息失败,原因:%@", [engineError localizedDescription]];
        [SIAlertView showWithTitle:@"提示" andMessage:message text1:@"重新获取" text2:@"关闭" okBlock:^{
            [self refreshProductList];
        } cancelBlock:^{
        }];
    }];
}


// 刷新当前选择的产品类别(如美食)和菜单(如今日团购)下的产品数据
- (void)refreshProductListOnSuccess:(ArrayBlock)onSuccess onError:(ErrorBlock)onError
{
    currentPageIndex = 0;
    
    NSDictionary *dic = [Utilities getCurrentShowCity];
    NSString *cityCodeStr = dic[@"areacode"];
    NSInteger cityId = cityCodeStr.integerValue;
    
    [RESTFulEngine getProductListWithPlatformIdentifier:1 cityId:cityId typeId:currentProductTypeId groupId:currentProductGroupId coordinate:currentCoordinate distance:kDefaultDistance pageIndex:kDefaultPageIndex pageSize:kDefaultPageSize sortNumber:currentProductSortId keyWord:@"0" onSuccess:^(NSMutableArray *listOfModelBaseObjects) {
        onSuccess(listOfModelBaseObjects);
    } onError:^(NSError *engineError) {
        onError(engineError);
    }];
}


// 通过地图的方式来展示商品
- (void)showProductListOnMap:(id)sender
{
    ProductOnMapController *POMC = [[ProductOnMapController alloc] initWithNibName:@"ProductOnMapController" bundle:nil];
    [self.navigationController pushViewController:POMC animated:YES];
    // 产品列表的数据由ProductListView来维护(比如刷新时移除之前的数据显示新的数据,加载时添加获取数据到数组末尾),TunaGouController只负责提供数据
    POMC.productListArray = self.productListView.productListArray; 
}

// 呈现城市列表界面
- (void)selectCity:(UIButton *)sender
{
    [self presentModalViewController:self.cityListController animated:YES];
}


// 呈现搜索界面
- (void)showSearchProductView:(id)sender
{
    SearchProductController *SPC = [[SearchProductController alloc] initWithNibName:@"SearchProductController" bundle:nil];
    [self.navigationController pushViewController:SPC animated:YES];
}

@end
