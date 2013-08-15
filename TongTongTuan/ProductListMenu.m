//
//  ProductListMenu.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-17.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ProductListMenu.h"
#import "Defines.h"
#import "RESTFulEngine.h"
#import "ProductTypeCell.h"
#import "ProductSubTypeCell.h"
#import "MenuCell.h"
#import "SIAlertView.h"

#define kAnimationDuration 0.3
#define kTagLeftDropView   2013
#define kTagMiddleDropView 2014
#define kTagRightDropView  2015


@interface ProductListMenu()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView                  *topMenuView;
@property (nonatomic, strong) UIView                  *leftDropView;
@property (nonatomic, strong) UIView                  *middleDropView;
@property (nonatomic, strong) UIView                  *rightDropView;
@property (nonatomic, strong) UIView                  *maskView;
@property (nonatomic, strong) UIView                  *currentExpandDropView;
@property (nonatomic, strong) UIButton                *leftDropViewButton;
@property (nonatomic, strong) UIButton                *middleDropViewButton;
@property (nonatomic, strong) UIButton                *rightDropViewButton;
@property (nonatomic, strong) UITableView             *productTypeTableView;
@property (nonatomic, strong) UITableView             *productSubTypeTableView;
@property (nonatomic, strong) UITableView             *middelDropTableView;
@property (nonatomic, strong) UITableView             *sortProductTableView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator1, *activityIndicator2, *activityIndicator3;
@property (nonatomic, copy)   NSArray                 *productTypeDataSource;
@property (nonatomic, strong) NSArray                 *productSubTypeDataSource;
@property (nonatomic, copy)   NSArray                 *middleDropViewDataSource;
@property (nonatomic, strong) NSArray                 *sortDataSource;
@property (nonatomic, assign) BOOL                    expandLeftDropView;
@property (nonatomic, assign) BOOL                    expandMiddleDropView;
@property (nonatomic, assign) BOOL                    expandRightDropView;
@property (nonatomic, assign) BOOL                    isLoadingProductTypeData, isCompletedLoadProductTypeData;
@property (nonatomic, assign) BOOL                    isLoadingMiddleDropViewData, isCompletedLoadMiddleDropViewData;
@property (nonatomic, assign) BOOL                    isLoadingSortTypeData, isCompletedLoadSortTypeData;
@end

@implementation ProductListMenu

+ (ProductListMenu *)showInView:(UIView *)superView
{
    ProductListMenu *menu = [ProductListMenu shareInstance];
    [superView addSubview:menu];
    return menu;
}


+ (ProductListMenu *)shareInstance
{
    static ProductListMenu *menu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[ProductListMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopMenuViewHeight)];
    });
    return menu;
}

#pragma mark - Init
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    
    return self;
}


- (void)commonInit
{
    [self addSubview:self.maskView];
    [self addSubview:self.leftDropView];
    [self addSubview:self.middleDropView];
    [self addSubview:self.rightDropView];
    [self addSubview:self.topMenuView];
    
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.expandLeftDropView = NO;
    self.expandMiddleDropView = NO;
    self.expandRightDropView = NO;
    self.isLoadingProductTypeData  = NO;
    self.isCompletedLoadProductTypeData = NO;
    self.isLoadingMiddleDropViewData = NO;
    self.isCompletedLoadMiddleDropViewData = NO;
    self.isLoadingSortTypeData = NO;
    self.isCompletedLoadSortTypeData = NO;
    
    [self registerNibFile];
    [self loadProductTypeData];
    [self loadMiddleDropViewData];
    [self loadSortTypeData];
}


- (void)registerNibFile
{
    [self.productTypeTableView registerNib:[UINib nibWithNibName:@"ProductTypeCell" bundle:nil]
                            forCellReuseIdentifier:@"ProductTypeCell"];
    [self.productSubTypeTableView registerNib:[UINib nibWithNibName:@"ProductSubTypeCell" bundle:nil]
                       forCellReuseIdentifier:@"ProductSubTypeCell"];
    [self.middelDropTableView registerNib:[UINib nibWithNibName:@"MenuCell"
                                                             bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    [self.sortProductTableView registerNib:[UINib nibWithNibName:@"MenuCell"
                                                         bundle:nil] forCellReuseIdentifier:@"MenuCell"];
}


#pragma mark Loading Data
- (void)loadProductTypeData
{
    if(self.isLoadingProductTypeData == NO && self.isCompletedLoadProductTypeData == NO)
    {
        self.isLoadingProductTypeData = YES;
        self.isCompletedLoadProductTypeData = NO;
        [self.activityIndicator1 startAnimating];
        
        [RESTFulEngine getProductTypeOnSuccess:^(NSMutableArray *listOfModelBaseObjects){
            self.isLoadingProductTypeData = NO;
            self.isCompletedLoadProductTypeData = YES;
            [self.activityIndicator1 stopAnimating];
            
            self.productTypeDataSource = listOfModelBaseObjects;
            [self.productTypeTableView reloadData];
            
        } onError:^(NSError *engineError) {
            self.isLoadingProductTypeData = NO;
            self.isCompletedLoadProductTypeData = NO;
            [self.activityIndicator1 stopAnimating];

            [SIAlertView showWithTitle:@"提示" andMessage:@"获取商品类别失败" text1:@"重新获取" text2:@"关闭" okBlock:^{
                [self loadProductTypeData];
            } cancelBlock:^{}];
        }];
    }
}


-(void)loadMiddleDropViewData
{
    if(self.isLoadingMiddleDropViewData == NO && self.isCompletedLoadMiddleDropViewData == NO)
    {
        self.isLoadingMiddleDropViewData = YES;
        self.isCompletedLoadMiddleDropViewData = NO;
        [self.activityIndicator2 startAnimating];
        
        [RESTFulEngine getMenuOnSuccess:^(NSMutableArray *listOfModelBaseObjects) {
            self.isLoadingMiddleDropViewData = NO;
            self.isCompletedLoadMiddleDropViewData = YES;
            [self.activityIndicator2 stopAnimating];
            
            self.middleDropViewDataSource = listOfModelBaseObjects;
            [self.middelDropTableView reloadData];
        } onError:^(NSError *engineError) {
            self.isLoadingMiddleDropViewData = NO;
            self.isCompletedLoadMiddleDropViewData = NO;
            [self.activityIndicator2 stopAnimating];

            [SIAlertView showWithTitle:@"提示" andMessage:@"获取商品菜单失败" text1:@"重新获取" text2:@"关闭" okBlock:^{
                [self loadMiddleDropViewData];
            } cancelBlock:^{}];
        }];
    }
}


- (void)loadSortTypeData
{
    self.sortDataSource = @[@"默认排序", @"价格最高", @"价格最低", @"人气最高", @"离我最近", @"最新发布"];
    [self.sortProductTableView reloadData];
}


#pragma mark - geter
- (UIView *)topMenuView
{
    if(_topMenuView)
    {
        return _topMenuView;
    }
    _topMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopMenuViewHeight)];
    [_topMenuView addSubview:self.leftDropViewButton];
    [_topMenuView addSubview:self.middleDropViewButton];
    [_topMenuView addSubview:self.rightDropViewButton];
    return _topMenuView;
}


- (UIView *)leftDropView
{
    if(_leftDropView)
    {
        return _leftDropView;
    }
    
    _leftDropView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopMenuViewHeight, SCREEN_WIDTH, 0)];
    _leftDropView.tag = kTagLeftDropView;
    [_leftDropView addSubview:self.productTypeTableView];
    [_leftDropView addSubview:self.productSubTypeTableView];
    return _leftDropView;
}


- (UIView *)middleDropView
{
    if(_middleDropView)
    {
        return  _middleDropView;
    }
    
    _middleDropView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopMenuViewHeight, SCREEN_WIDTH, 0)];
    _middleDropView.tag = kTagMiddleDropView;
    [_middleDropView addSubview:self.middelDropTableView];
    return _middleDropView;
}


- (UIView *)rightDropView
{
    if(_rightDropView)
    {
        return _rightDropView;
    }
    
    _rightDropView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopMenuViewHeight, SCREEN_WIDTH, 0)];
    _rightDropView.tag = kTagRightDropView;
    [_rightDropView addSubview:self.sortProductTableView];
    return _rightDropView;
}


- (UIView *)maskView
{
    if(_maskView)
    {
        return _maskView;
    }
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSelfHeight)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.5;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_maskView addGestureRecognizer:gesture];
    return _maskView;
}


- (UITableView *)productTypeTableView
{
    if(_productTypeTableView)
    {
        return _productTypeTableView;
    }
    
    _productTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 0)];
    _productTypeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _productTypeTableView.delegate = self;
    _productTypeTableView.dataSource = self;
    [_productTypeTableView addSubview:self.activityIndicator1];
    return _productTypeTableView;
}


- (UITableView *)productSubTypeTableView
{
    if(_productSubTypeTableView)
    {
        return _productSubTypeTableView;
    }
    
    _productSubTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 0)];
    _productSubTypeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _productTypeTableView.separatorColor = [UIColor redColor];
    _productSubTypeTableView.delegate = self;
    _productSubTypeTableView.dataSource = self;
    return _productSubTypeTableView;
}


- (UITableView *)middelDropTableView
{
    if(_middelDropTableView)
    {
        return _middelDropTableView;
    }
    
    _middelDropTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _middelDropTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _middelDropTableView.delegate = self;
    _middelDropTableView.dataSource = self;
    [_middelDropTableView addSubview:self.activityIndicator2];
    return _middelDropTableView;
}


- (UITableView *)sortProductTableView
{
    if(_sortProductTableView)
    {
        return _sortProductTableView;
    }
    
    _sortProductTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _sortProductTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _sortProductTableView.delegate =self;
    _sortProductTableView.dataSource = self;
    return _sortProductTableView;
}


- (UIActivityIndicatorView *)activityIndicator1
{
    if(_activityIndicator1)
    {
        return _activityIndicator1;
    }
    
    _activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator1.hidesWhenStopped = YES;
    _activityIndicator1.center = CGPointMake(SCREEN_WIDTH/4, kDropViewHeight/2);
    [_activityIndicator1 startAnimating];
    return _activityIndicator1;
}


- (UIActivityIndicatorView *)activityIndicator2
{
    if(_activityIndicator2)
    {
        return _activityIndicator2;
    }
    
    _activityIndicator2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator2.hidesWhenStopped = YES;
    _activityIndicator2.center = CGPointMake(SCREEN_WIDTH/4, kDropViewHeight/2);
    [_activityIndicator2 startAnimating];
    return _activityIndicator2;
}


- (UIButton *)leftDropViewButton
{
    if(_leftDropViewButton)
    {
        return _leftDropViewButton;
    }
    
    _leftDropViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0 * kButtonWidth, 0, kButtonWidth, kTopMenuViewHeight)];
    [_leftDropViewButton setTitle:@"全部" forState:UIControlStateNormal];
    [_leftDropViewButton addTarget:self action:@selector(expandLeftDropView:) forControlEvents:UIControlEventTouchUpInside];
    return _leftDropViewButton;
}


- (UIButton *)middleDropViewButton
{
    if(_middleDropViewButton)
    {
        return _middleDropViewButton;
    }
    
    _middleDropViewButton = [[UIButton alloc] initWithFrame:CGRectMake(1 * kButtonWidth, 0, kButtonWidth, kTopMenuViewHeight)];
    [_middleDropViewButton setTitle:@"今日团购" forState:UIControlStateNormal];
    [_middleDropViewButton addTarget:self action:@selector(expandMiddleDropView:) forControlEvents:UIControlEventTouchUpInside];
    return _middleDropViewButton;
}


- (UIButton *)rightDropViewButton
{
    if(_rightDropViewButton)
    {
        return _rightDropViewButton;
    }
    
    _rightDropViewButton = [[UIButton alloc] initWithFrame:CGRectMake(2 * kButtonWidth, 0, kButtonWidth, kTopMenuViewHeight)];
    [_rightDropViewButton setTitle:@"默认排序" forState:UIControlStateNormal];
    [_rightDropViewButton addTarget:self action:@selector(expandRightDropView:) forControlEvents:UIControlEventTouchUpInside];
    return _rightDropViewButton;
}


#pragma mark - Action
- (void)expandLeftDropView:(UIButton *)sender
{
    if(self.expandLeftDropView == NO)
    {
        [self loadProductTypeData];
    }
    [self expandOrHideDropView:self.leftDropView expandState:&_expandLeftDropView];
}


- (void)expandMiddleDropView:(UIButton *)sender
{
    if(self.expandMiddleDropView == NO)
    {
        [self loadMiddleDropViewData];
    }
    [self expandOrHideDropView:self.middleDropView expandState:&_expandMiddleDropView];
}


- (void)expandRightDropView:(UIButton *)sender
{
    [self expandOrHideDropView:self.rightDropView expandState:&_expandRightDropView];
}


- (void)expandOrHideDropView:(UIView *)dropView expandState:(BOOL *)state
{
    if(self.currentExpandDropView && [self.currentExpandDropView isEqual:dropView] == NO)
    {
        CGRect f = self.currentExpandDropView.frame;
        f.size.height = 0;
        self.currentExpandDropView.frame = f;
        
        // 将前一个下拉视图标记为没展开
        switch(self.currentExpandDropView.tag)
        {
            case kTagLeftDropView:
                self.expandLeftDropView = NO;
                break;
            case kTagMiddleDropView:
                self.expandMiddleDropView = NO;
                break;
            case kTagRightDropView:
                self.expandRightDropView = NO;
                break;
            default:
                break;
        }
    }
    
    CGRect f2 = dropView.frame;
    CGRect f3 = self.frame;
    
    if(*state)
    {
        f2.size.height = 0;
        f3.size.height = kTopMenuViewHeight;
        self.currentExpandDropView = nil;
        *state = NO;
    }else
    {
        f2.size.height = kDropViewHeight;
        f3.size.height = kSelfHeight;
        self.currentExpandDropView = dropView;
        *state = YES;
    }

    [UIView animateWithDuration:kAnimationDuration animations:^{
        dropView.frame = f2;
        self.frame = f3;
    } completion:^(BOOL finished) {
    }];
}


- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if(self.currentExpandDropView)
    {
        switch(self.currentExpandDropView.tag)
        {
            case kTagLeftDropView:
                [self expandOrHideDropView:self.currentExpandDropView expandState:&_expandLeftDropView];
                break;
            case kTagMiddleDropView:
                [self expandOrHideDropView:self.currentExpandDropView expandState:&_expandMiddleDropView];
                break;
            case kTagRightDropView:
                [self expandOrHideDropView:self.currentExpandDropView expandState:&_expandRightDropView];
                break;
            default:
                break;
        }
    }
}


#pragma mark - UITableView Datasource And Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.productTypeTableView])
    {
        return self.productTypeDataSource.count;
    }else if([tableView isEqual:self.productSubTypeTableView])
    {
        return self.productSubTypeDataSource.count;
    }else if([tableView isEqual:self.middelDropTableView])
    {
        return self.middleDropViewDataSource.count;
    }else if([tableView isEqual:self.sortProductTableView])
    {
        return self.sortDataSource.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.productTypeTableView])
    {
        ProductTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductTypeCell"];
        [cell updateView:self.productTypeDataSource[indexPath.row]];
        return cell;
        
    }else if([tableView isEqual:self.productSubTypeTableView])
    {
        ProductSubTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductSubTypeCell"];
        [cell updateView:self.productSubTypeDataSource[indexPath.row]];
        return cell;
    }else if([tableView isEqual:self.middelDropTableView])
    {   MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        [cell updateView:self.middleDropViewDataSource[indexPath.row]];
        return cell;
        
    }else if([tableView isEqual:self.sortProductTableView])
    {
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        cell.nameLabel.text = self.sortDataSource[indexPath.row];
        return cell;
    }
    
    return nil;
}


// zhanghao2524 zhanghao0614
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.productTypeTableView])
    {
        ProductType *productType = self.productTypeDataSource[indexPath.row];
        [self.leftDropViewButton setTitle:productType.typeName forState:UIControlStateNormal];
        self.productSubTypeDataSource = productType.listPro_ProType;
        [self.productSubTypeTableView reloadData];
        
        if(productType.listPro_ProType == nil || productType.listPro_ProType.count == 0)
        {
            [self expandOrHideDropView:self.currentExpandDropView expandState:&_expandLeftDropView];

            if(self.delegate)
            {
                [self.delegate productListTopMenu:self didSelectedProductType:self.productTypeDataSource[indexPath.row]];
            }
        }
        
    }else if([tableView isEqual:self.productSubTypeTableView])
    {
        ProductType *productType = self.productSubTypeDataSource[indexPath.row];
        [self.leftDropViewButton setTitle:productType.typeName forState:UIControlStateNormal];
        [self expandOrHideDropView:self.currentExpandDropView expandState:&_expandLeftDropView];

       if(self.delegate)
       {
            [self.delegate productListTopMenu:self didSelectedProductType:self.productSubTypeDataSource[indexPath.row]];
       }

    }else if([tableView isEqual:self.middelDropTableView])
    {
        Menu *menu = self.middleDropViewDataSource[indexPath.row];
        [self.middleDropViewButton setTitle:menu.teamname forState:UIControlStateNormal];
        [self expandOrHideDropView:self.currentExpandDropView expandState:&_expandMiddleDropView];

        if(self.delegate)
        {
            [self.delegate productListTopMenu:self didSelectedMenu:self.middleDropViewDataSource[indexPath.row]];
        }
    }else if([tableView isEqual:self.sortProductTableView])
    {
        NSString *str = self.sortDataSource[indexPath.row];
        [self.rightDropViewButton setTitle:str forState:UIControlStateNormal];
        [self expandOrHideDropView:self.currentExpandDropView expandState:&_expandRightDropView];

        if(self.delegate)
        {
            NSInteger index = indexPath.row + 1;
            [self.delegate productListTopMenu:self didSelectedSortType:index];
        }
    }
}
@end
