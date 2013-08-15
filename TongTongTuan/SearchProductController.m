//
//  SearchProductController.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "SearchProductController.h"
#import "RESTFulEngine.h"
#import "ProductListCell.h"
#import "Product.h"
#import "SearchProductListController.h"
#import "SIAlertView.h"

#define SearchHistoryFilePath @"searchHistory.plist"

@interface SearchProductController()<UITableViewDataSource,
                                     UISearchBarDelegate,
                                     UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *searchHistoryArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL searching;
@property (strong, nonatomic) IBOutlet UIButton *clearSearchRecordButton;

@end

@implementation SearchProductController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"搜索产品";
    }
    return self;
}

// 在视图每次出现和消失时都刷新搜索记录列表
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *path = [RESTFulEngine cacheFilePath:SearchHistoryFilePath];
    self.searchHistoryArray = [NSMutableArray arrayWithContentsOfFile:path];
    if(self.searchHistoryArray && self.searchHistoryArray.count){
        self.tableView.tableFooterView = self.clearSearchRecordButton;
        [self.tableView reloadData];
    }else{
        self.searchHistoryArray = [NSMutableArray new];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *path = [RESTFulEngine cacheFilePath:SearchHistoryFilePath];
    if([self.searchHistoryArray writeToFile:path atomically:NO] ==  NO){
        NSLog(@"保存搜索纪录失败");
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setClearSearchRecordButton:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView 数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchHistoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchHistoryCell"];
    }
    
    cell.textLabel.text = self.searchHistoryArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *key = self.searchHistoryArray[indexPath.row];
    [self searchProductWithKeyword:key];
}

#pragma mark - UISearchBarDelegate

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self searchProductWithKeyword:searchBar.text];
}

// 使用关键字搜索商品
- (void)searchProductWithKeyword:(NSString *)keyword
{
    if(self.searching){
        return;
    }
    self.searching = YES;
        
    #warning 处理搜索等待提示
        [RESTFulEngine searchProductWithKeyword:keyword onSuccess:^(NSMutableArray *listOfModelBaseObjects) {
            self.searching = NO;
            [self addSearchHistoryWithKey:keyword];
            self.tableView.tableFooterView = self.clearSearchRecordButton;
            [self.tableView reloadData];
            
            if(listOfModelBaseObjects.count == 0){
               [SIAlertView showWithMessage:@"没有搜索到商品" text1:@"关闭" okBlock:^{}];
            }else{
                SearchProductListController *SPL = [[SearchProductListController alloc] init];
                [self.navigationController pushViewController:SPL animated:YES];
                [SPL.productListView refreshListhWithDataSource:listOfModelBaseObjects];
            }
        } onError:^(NSError *engineError) {
            self.searching = NO;
            NSString *reason = [NSString stringWithFormat:@"搜索失败,原因:%@", [engineError localizedDescription]];
            [SIAlertView showWithMessage:reason text1:@"关闭" okBlock:^{}];
        }];
}

// 添加搜索记录项目，去掉重复的搜索项目
- (void)addSearchHistoryWithKey:(NSString *)key
{
    for (NSString *k in self.searchHistoryArray){
        if([k isEqualToString:key]){
            [self.searchHistoryArray removeObject:k];
            break;
        }
    }
    [self.searchHistoryArray insertObject:key atIndex:0];
}

// 清除搜索记录
- (IBAction)clearSearchRecord:(id)sender
{
    [self.searchHistoryArray removeAllObjects];
    self.tableView.tableFooterView = nil;
    [self.tableView reloadData];
}

@end
