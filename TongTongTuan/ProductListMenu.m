//
//  ProductListMenu.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-17.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ProductListMenu.h"
#import "Defines.h"

#define kTopMenuViewHeight 40.0
#define kButtonWidth (SCREEN_WIDTH / 3.0)
#define kSelfHeight  (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT -TAB_BAR_HEIGHT)
#define kDropViewHeight (kSelfHeight - kTopMenuViewHeight - 60.0)
#define kAnimationDuration 0.3

#define kTagLeftDropView   2013
#define kTagMiddleDropView 2014
#define kTagRightDropView  2015

@interface ProductListMenu()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView      *topMenuView;
@property (nonatomic, strong) UIView      *leftDropView;
@property (nonatomic, strong) UIView      *middleDropView;
@property (nonatomic, strong) UIView      *rightDropView;
@property (nonatomic, strong) UIView      *maskView;
@property (nonatomic, strong) UIView      *currentExpandDropView;
@property (nonatomic, strong) UIButton    *leftDropViewButton;
@property (nonatomic, strong) UIButton    *middleDropViewButton;
@property (nonatomic, strong) UIButton    *rightDropViewButton;
@property (nonatomic, strong) UITableView *productTypeLevelOneTableView;
@property (nonatomic, strong) UITableView *productTypeLevelTwoTableView;
@property (nonatomic, strong) UITableView *middelDropTableView;
@property (nonatomic, strong) UITableView *sortProductTableView;
@property (nonatomic, assign) BOOL expandLeftDropView, expandMiddleDropView, expandRightDropView;
@end

@implementation ProductListMenu

+ (void)showInView:(UIView *)superView
{
    [superView addSubview:[ProductListMenu shareInstance]];
}


+ (ProductListMenu *)shareInstance
{
    static ProductListMenu *menu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[ProductListMenu alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, kTopMenuViewHeight)];
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
    [_leftDropView addSubview:self.productTypeLevelOneTableView];
    [_leftDropView addSubview:self.productTypeLevelTwoTableView];
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
    _maskView.alpha = 0.3;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_maskView addGestureRecognizer:gesture];
    return _maskView;
}


- (UITableView *)productTypeLevelOneTableView
{
    if(_productTypeLevelOneTableView)
    {
        return _productTypeLevelOneTableView;
    }
    
    _productTypeLevelOneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 0)];
    _productTypeLevelOneTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _productTypeLevelOneTableView.delegate = self;
    _productTypeLevelOneTableView.dataSource = self;
    return _productTypeLevelOneTableView;
}


- (UITableView *)productTypeLevelTwoTableView
{
    if(_productTypeLevelTwoTableView)
    {
        return _productTypeLevelTwoTableView;
    }
    
    _productTypeLevelTwoTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 0)];
    _productTypeLevelTwoTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _productTypeLevelOneTableView.separatorColor = [UIColor redColor];
    _productTypeLevelTwoTableView.delegate = self;
    _productTypeLevelTwoTableView.dataSource = self;
    return _productTypeLevelTwoTableView;
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


- (UIButton *)leftDropViewButton
{
    if(_leftDropViewButton)
    {
        return _leftDropViewButton;
    }
    
    _leftDropViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0 * kButtonWidth, 0, kButtonWidth, kTopMenuViewHeight)];
    [_leftDropViewButton setTitle:@"XX" forState:UIControlStateNormal];
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
    [_middleDropViewButton setTitle:@"YY" forState:UIControlStateNormal];
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
    [_rightDropViewButton setTitle:@"ZZ" forState:UIControlStateNormal];
    [_rightDropViewButton addTarget:self action:@selector(expandRightDropView:) forControlEvents:UIControlEventTouchUpInside];
    return _rightDropViewButton;
}


#pragma mark - Action
- (void)expandLeftDropView:(UIButton *)sender
{
    [self expandOrHideDropView:self.leftDropView expandState:&_expandLeftDropView];
}


- (void)expandMiddleDropView:(UIButton *)sender
{
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
    if([tableView isEqual:self.productTypeLevelOneTableView])
    {
        return 0;
    }else if([tableView isEqual:self.productTypeLevelTwoTableView])
    {
        return 0;
    }else if([tableView isEqual:self.middelDropTableView])
    {
        
    }else if([tableView isEqual:self.sortProductTableView])
    {
        
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.productTypeLevelOneTableView])
    {
        
    }else if([tableView isEqual:self.productTypeLevelTwoTableView])
    {
        
    }else if([tableView isEqual:self.middelDropTableView])
    {
        
    }else if([tableView isEqual:self.sortProductTableView])
    {
        
    }
    
    return nil;
}

@end
