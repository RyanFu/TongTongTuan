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

@interface TuanGouController()<ProductListMenuDelegate,ProductListViewDelegate, CityListControllerDelegate,LocationManagerDelegate>
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

    self.view.backgroundColor = [UIColor whiteColor];
    self.productListView = [ProductListView showInView:self.view withFrame:CGRectMake(0,kTopMenuViewHeight , SCREEN_WIDTH,SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-kTopMenuViewHeight-TAB_BAR_HEIGHT)];
    self.productListView.delegate = self;
    
    [[ProductListMenu showInView:self.view] setDelegate:self];

    self.navigationItem.titleView = self.navigationItemTitleView;
    self.navigationItem.leftBarButtonItem = self.mapBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.searchProductBarButtonItem;
    
    CGFloat lon = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentCoordinateLongitude];
    CGFloat lat = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentCoordinateLatitude];
    if(lon != 0 && lat != 0)
    {
        currentCoordinate = CLLocationCoordinate2DMake(lat, lon);
    }else{
        currentCoordinate = kGuiYanCoordinate;
    }
    
    self.cityListController = [[CityListController alloc] initWithNibName:@"CityListController" bundle:nil];
    self.cityListController.delegate = self;

    self.locationManager = [[LocationManager alloc] init];
    self.locationManager.delegate = self;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kCurrentCity];
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
    if(currentProductSortId == 5)
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
    [[NSUserDefaults standardUserDefaults] setObject:cityDicationary forKey:kCurrentCity];
    [self.cityButton setTitle:cityDicationary[@"areaname"] forState:UIControlStateNormal];
    [self refreshProductList];
}


#pragma mark - LocationManagerDelegate
- (void)locationManagerSuccess:(CLLocationCoordinate2D)coordinate cityDictionary:(NSDictionary *)cityDic name:(NSString *)name
{
    currentCoordinate = coordinate;
    [[NSUserDefaults standardUserDefaults] setFloat:coordinate.latitude forKey:kCurrentCoordinateLatitude];
    [[NSUserDefaults standardUserDefaults] setFloat:coordinate.longitude forKey:kCurrentCoordinateLongitude];
    
    [[NSUserDefaults standardUserDefaults] setObject:cityDic forKey:kLocationCity];
    [[NSUserDefaults standardUserDefaults] setObject:cityDic forKey:kCurrentCity];
    [self.cityButton setTitle:cityDic[@"areaname"] forState:UIControlStateNormal];
    [self.cityListController setLocationCtiy:cityDic];
    [self refreshProductList];
}


- (void)locationManagerFial
{
    currentCoordinate = kGuiYanCoordinate;
    NSDictionary *cityDic = @{@"areaname":@"贵阳市",@"areacode":@"520100"};
    [[NSUserDefaults standardUserDefaults] setObject:cityDic forKey:kCurrentCity];
    [self.cityButton setTitle:cityDic[@"areaname"] forState:UIControlStateNormal];
    [self.cityListController setLocationCtiy:cityDic];
    [self refreshProductList];
}


#pragma mark - Action

- (void)refreshProductList
{
    [self refreshProductListOnSuccess:^(NSMutableArray *listOfModelBaseObjects) {
        [self.productListView refreshListhWithDataSource:listOfModelBaseObjects];
    } onError:^(NSError *engineError) {
        NSString *message = [NSString stringWithFormat:@"获取产品信息失败,原因:%@", [engineError localizedDescription]];
        [SIAlertView showWithTitle:@"提示" andMessage:message text1:@"重新获取" text2:@"关闭" okBlock:^{
            [self refreshProductList];
        } cancelBlock:^{
        }];
    }];
}


- (void)refreshProductListOnSuccess:(ArrayBlock)onSuccess onError:(ErrorBlock)onError
{
    currentPageIndex = 0;
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kCurrentCity];
    NSString *cityCodeStr = dic[@"areacode"];
    NSInteger cityId = cityCodeStr.integerValue;
    
    [RESTFulEngine getProductListWithPlatformIdentifier:1 cityId:cityId typeId:currentProductTypeId groupId:currentProductGroupId coordinate:currentCoordinate distance:kDefaultDistance pageIndex:kDefaultPageIndex pageSize:kDefaultPageSize sortNumber:currentProductSortId keyWord:@"0" onSuccess:^(NSMutableArray *listOfModelBaseObjects) {
        onSuccess(listOfModelBaseObjects);
    } onError:^(NSError *engineError) {
        onError(engineError);
    }];
}


- (void)showProductListOnMap:(id)sender
{
    ProductOnMapController *POMC = [[ProductOnMapController alloc] initWithNibName:@"ProductOnMapController" bundle:nil];
    [self.navigationController pushViewController:POMC animated:YES];
}


- (void)selectCity:(UIButton *)sender
{
    [self presentModalViewController:self.cityListController animated:YES];
}


- (void)showSearchProductView:(id)sender
{
    SearchProductController *SPC = [[SearchProductController alloc] initWithNibName:@"SearchProductController" bundle:nil];
    [self.navigationController pushViewController:SPC animated:YES];
}

@end
