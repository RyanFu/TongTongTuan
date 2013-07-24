//
//  ProductListView.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-17.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ProductListView.h"
#import "ProductListCell.h"
#import "ODRefreshControl.h"
#import "UIImageView+WebCache.h"

@interface ProductListView()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *productListTableView;
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefreshing, isLoadingMore;
@end

@implementation ProductListView

+ (ProductListView *)showInView:(UIView *)superView withFrame:(CGRect )frame
{
    ProductListView *list = [[ProductListView alloc] initWithFrame:frame];
    [superView addSubview:list];
    return list;
}


- (id)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        self.tableViewDataSource = [NSMutableArray array];
        self.isRefreshing = NO;
        self.isLoadingMore = NO;
        
        self.productListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.productListTableView.delegate = self;
        self.productListTableView.dataSource = self;
        self.productListTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.productListTableView setRowHeight:110.0];
        [self.productListTableView registerNib:[UINib nibWithNibName:@"ProductListCell" bundle:nil]
                        forCellReuseIdentifier:@"ProductListCell"];
        [self addSubview:self.productListTableView];
        
        self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.productListTableView];
        [self.refreshControl addTarget:self action:@selector(pullDownToRefresh) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}


- (void)refreshListhWithDataSource:(NSArray *)modelObjectArray
{
    [self.tableViewDataSource removeAllObjects];
    [self.tableViewDataSource addObjectsFromArray:modelObjectArray];
    [self.productListTableView reloadData];
}


#pragma mark - UITableView Source Data And Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductListCell"];
    Product *product = self.tableViewDataSource[indexPath.row];
    [cell updateView:product];
    if(CGSizeEqualToSize(cell.thumImageView.image.size, CGSizeZero))
    {
        NSLog(@"%@", product.propic);
    }
    
    if(tableView.isDecelerating == NO && tableView.isDragging == NO)
    {
        
    }
    return cell ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.isDragging == NO)
    {
       NSArray *visibleRows = [self.productListTableView indexPathsForVisibleRows];
      for(NSIndexPath *indexPath in visibleRows)
      {
          Product *product = self.tableViewDataSource[indexPath.row];
          ProductListCell *cell = (ProductListCell *)[self.productListTableView cellForRowAtIndexPath:indexPath];
          if(cell.thumImageView.image == nil)
          {
              [cell.thumImageView setImageWithURL:[NSURL URLWithString:product.propic] placeholderImage:nil];
          }
      }
    }
}


#pragma mark - 

- (void)pullDownToRefresh
{
    if(self.isRefreshing == NO)
    {
        if(self.delegate)
        {
            self.isRefreshing = YES;
            [self.refreshControl beginRefreshing];
            [self.delegate productListView:self refreshOnSuccess:^(NSMutableArray *listOfModelBaseObjects)
            {
                self.isRefreshing = NO;
                [self.refreshControl endRefreshing];
                [self refreshListhWithDataSource:listOfModelBaseObjects];
            } onError:^(NSError *engineError) {
                self.isRefreshing = NO;
                [self.refreshControl endRefreshing];
            }];
        }
    }
}

@end
