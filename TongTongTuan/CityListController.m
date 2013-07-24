//
//  CityListController.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-22.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "CityListController.h"
#import "RESTFulEngine.h"
#import "Defines.h"

@interface CityListController()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary *cityListDictionary;
@end

@implementation CityListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [RESTFulEngine getCityListOnSuccess:^(NSMutableDictionary *dictionary) {
            self.cityListDictionary = dictionary;
            self.keys = [dictionary allKeys];
#pragma mark - 使用适合的排序算法

            [self.keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            NSDictionary *cityDic = [[NSUserDefaults standardUserDefaults] objectForKey:kLocationCity];
            if(cityDic)
            {
                [self setLocationCtiy:cityDic];
            }
            [self.tableView reloadData];
        } onError:^(NSError *engineError) {
            
        }];
    }
    return self;
}


#pragma mark - UITableViewDataSource And Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keys.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.keys[section];
    NSArray *sectionItems = self.cityListDictionary[key];
    return sectionItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cityListCell = @"CityListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityListCell];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityListCell];
    }
    
    NSString *key = self.keys[indexPath.section];
    NSArray *sectionItems = self.cityListDictionary[key];
    NSDictionary *cityDic = sectionItems[indexPath.row];
    cell.textLabel.text = cityDic[@"areaname"];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = self.keys[section];
    return [str isEqualToString:@"#"] ? @"定位城市" : str;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.delegate)
    {
        NSString *key = self.keys[indexPath.section];
        NSArray *sectionItems = self.cityListDictionary[key];
        NSDictionary *cityDic = sectionItems[indexPath.row];
        [self.delegate cityListController:self cityDicationary:cityDic];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Action
- (void)setLocationCtiy:(NSDictionary *)cityDic
{
    NSMutableArray *array = self.cityListDictionary[@"#"];
    [array removeAllObjects];
    [array addObject:cityDic];
    [self.tableView reloadData];
}

- (IBAction)goBackProductListView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
