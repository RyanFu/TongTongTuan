//
//  RESTFulEngine.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-18.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "RESTFulEngine.h"
#import "Defines.h"
#import "ProductType.h"
#import "Menu.h"
#import "Product.h"
#import "City.h"
#import "Utilities.h"

#define kHost @"192.168.1.198"
#define kProductTypeDataCacheFile @"product_type_data.plist"
#define kMenuDataCacheFile @"menu_data.plist"
#define kCityListDataCacheFile @"city_data.plist"

@implementation RESTFulEngine
+ (RESTFulEngine *)shareInstance
{
    static RESTFulEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [[RESTFulEngine alloc] initWithHostName:kHost];
    });
    return engine;
}

// 获取商品类别(如:美食,电影...)
+ (MKNetworkOperation *)getProductTypeOnSuccess:(ArrayBlock)onSuccess onError:(ErrorBlock)onError
{
    NSMutableArray *modelDataArray = [NSMutableArray arrayWithContentsOfFile:[RESTFulEngine cacheFilePath:kProductTypeDataCacheFile]];
    // 若有缓存数据并且数据没有过期则使用缓存数据
    if(modelDataArray && [RESTFulEngine isCacheStale:kProductTypeDataCacheFile] == NO)
    {
        NSMutableArray *modelArray = [NSMutableArray new];
        for(NSMutableDictionary *dic in modelDataArray)
        {
            [modelArray addObject:[[ProductType alloc] initWithDictionary:dic]];
        }
        onSuccess(modelArray);
        return nil;
    }else
    {
        RESTFulEngine *engine = [RESTFulEngine shareInstance];
        MKNetworkOperation *operation = [engine operationWithPath:@"ProService/GetProType/1"];
        
        [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSArray *jsonArray = [completedOperation responseJSON];
            if([jsonArray writeToFile:[RESTFulEngine cacheFilePath:kProductTypeDataCacheFile] atomically:YES] == NO)
            {
                NSLog(@"保存产品类别数据失败");
            }
            
            NSMutableArray *modelArray = [NSMutableArray new];
            for(NSMutableDictionary *dic in jsonArray)
            {
                [modelArray addObject:[[ProductType alloc] initWithDictionary:dic]];
            }
            onSuccess(modelArray);
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            LHError(error);
            onError(error);
        }];
        
        [engine enqueueOperation:operation forceReload:YES];
        return operation;
    }
}


// 获取菜单数据(如今日团购 特惠活动 特产频道)
+ (MKNetworkOperation *)getMenuOnSuccess:(ArrayBlock)onSuccess onError:(ErrorBlock)onError
{
    NSMutableArray *modelDataArray = [NSMutableArray arrayWithContentsOfFile:[RESTFulEngine cacheFilePath:kMenuDataCacheFile]];
    // 若有缓存数据并且数据没有过期则使用缓存数据
    if(modelDataArray && [RESTFulEngine isCacheStale:kMenuDataCacheFile] == NO)
    {
        NSMutableArray *modelArray = [NSMutableArray new];
        for(NSMutableDictionary *dic in modelDataArray)
        {
            [modelArray addObject:[[Menu alloc] initWithDictionary:dic]];
        }
        onSuccess(modelArray);
        return nil;
    }else
    {
        RESTFulEngine *engine = [RESTFulEngine shareInstance];
        MKNetworkOperation *operation = [engine operationWithPath:@"ProService/GetType/1"];
        
        [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSArray *jsonArray = [completedOperation responseJSON];
            if([jsonArray writeToFile:[RESTFulEngine cacheFilePath:kMenuDataCacheFile] atomically:YES] == NO)
            {
                NSLog(@"保存产品类别数据失败");
            }
            
            NSMutableArray *modelArray = [NSMutableArray new];
            for(NSMutableDictionary *dic in jsonArray)
            {
                [modelArray addObject:[[Menu alloc] initWithDictionary:dic]];
            }
            onSuccess(modelArray);
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            LHError(error);
            onError(error);
        }];
        
        [engine enqueueOperation:operation forceReload:YES];
        return operation;
    }
}


// 获取城市列表
+ (MKNetworkOperation *)getCityListOnSuccess:(DictionaryBlock)onSuccess onError:(ErrorBlock)onError
{
    // 通过GPS定位获得当前的城市名称信息后，需要到保存城市列表的数据容器中查找对应城市的城市代码，而此时有可能城市列表的数据还没有从服务器
    // 端获取，所以在用户第一次使用App时从本地加载城市列表数据以避免上述情况发生
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:kFirstUseApp] == NO)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city_data" ofType:@"plist"];
        NSMutableDictionary *cityListDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstUseApp];
        onSuccess(cityListDictionary);
        return nil;
    }
    
    NSMutableDictionary *cityListDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[RESTFulEngine cacheFilePath:kCityListDataCacheFile]];
    if(cityListDictionary && [RESTFulEngine isCacheStale:kCityListDataCacheFile])
    {
        onSuccess(cityListDictionary);
        return nil;
    }else{
        RESTFulEngine *engine = [RESTFulEngine shareInstance];
        MKNetworkOperation *operation = [engine operationWithPath:@"SysService/GetAllList"];
        
        [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSMutableArray *jsonArray = [completedOperation responseJSON];
            NSMutableDictionary *cityList = [NSMutableDictionary new];
            [cityList setValue:[NSMutableArray new] forKey:@"#"];
            // 服务器端返回的数据格式不符客户端的要求，这里重新组织下数据结构
            for(NSMutableDictionary *dic in jsonArray)
            {
                cityList[dic[@"key"]] = dic[@"areainfo"];
            }
            
            if([cityList writeToFile:[RESTFulEngine cacheFilePath:kCityListDataCacheFile] atomically:YES] == NO){
                 NSLog(@"保存城市数据失败");
            }
            onSuccess(cityList);
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            LHError(error);
            onError(error);
        }];
        
        [engine enqueueOperation:operation forceReload:YES];
        return operation;
    }
}


// 获取产品列表
+ (MKNetworkOperation *)getProductListWithPlatformIdentifier:(NSInteger)pid
                                                   cityId:(NSInteger)cid
                                                   typeId:(NSInteger)tid
                                                  groupId:(NSInteger)gid
                                               coordinate:(CLLocationCoordinate2D)coordinate
                                                 distance:(NSUInteger)distance
                                                pageIndex:(NSUInteger)pageIndex
                                                 pageSize:(NSUInteger)pageSize
                                                  sortNumber:(NSInteger )sortNumber
                                                  keyWord:(NSString *)keyword
                                                onSuccess:(ArrayBlock)onSuccess
                                                  onError:(ErrorBlock)onError
{
    NSString *apiPath = [NSString stringWithFormat:@"ProService/GetProductList/%d/%d/%d/%d/%f/%f/%d/%d/%d/%d/%@", pid, cid, tid,gid, coordinate.longitude,coordinate.latitude,distance,pageIndex,pageSize, sortNumber, keyword];
    RESTFulEngine *engine = [RESTFulEngine shareInstance];
    MKNetworkOperation *operation = [engine operationWithPath:apiPath];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableArray *jsonArray = [completedOperation responseJSON];
        NSMutableArray *modelArray = [NSMutableArray new];
        for(NSMutableDictionary *dic in jsonArray)
        {
            [modelArray addObject:[[Product alloc] initWithDictionary:dic]];
        }
        onSuccess(modelArray);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        LHError(error);
        onError(error);
    }];
    
    [engine enqueueOperation:operation forceReload:YES];
    return operation;
}


// 搜索商品
+ (MKNetworkOperation *)searchProductWithKeyword:(NSString *)keyword
                                    onSuccess:(ArrayBlock)onSuccess
                                      onError:(ErrorBlock)onError
{
    
    // 获取地区代码，如果获取失败默认使用贵阳的地区代码520100
    NSInteger code;
    NSDictionary *dic = [Utilities getCurrentShowCity];
    if(dic){
        NSString *cityCodeStr = dic[@"areacode"];
        code = cityCodeStr.integerValue;
    }else{
        code = 520100;
    }
    
    RESTFulEngine *engine = [RESTFulEngine shareInstance];
    NSString *path = [NSString stringWithFormat:@"ProService/SearchProduct/%d/%@/1/1000",code,keyword];
    path = [path urlEncodedString];
    MKNetworkOperation *operation = [engine operationWithPath:path];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableArray *jsonArray = [completedOperation responseJSON];
        NSMutableArray *modelArray = [NSMutableArray new];
        for(NSMutableDictionary *dic in jsonArray)
        {
            [modelArray addObject:[[Product alloc] initWithDictionary:dic]];
        }
        onSuccess(modelArray);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        LHError(error);
        onError(error);
    }];
    
    [engine enqueueOperation:operation forceReload:YES];
    return operation;
}


+ (MKNetworkOperation *)getProductDetail:(Product *)product
                               onSuccess:(ModelBlock)onSuccess
                                 onError:(ErrorBlock)onError
{
    RESTFulEngine *engine = [RESTFulEngine shareInstance];
    CLLocationCoordinate2D coordinate = [Utilities getUserCoordinate];
    NSString *path =
    [NSString stringWithFormat:@"ProService/GetProduct/%d/%f/%f", product.pid,coordinate.longitude,coordinate.latitude];
    MKNetworkOperation *operation = [engine operationWithPath:path];

    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        onSuccess([[Product alloc] initWithDictionary:[completedOperation responseJSON]]);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        LHError(error);
        onError(error);
    }];
    
    [engine enqueueOperation:operation forceReload:YES];
    return operation;
}


// 缓存文件路径
+ (NSString *)cacheFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *CacheDirectory = paths[0];
    return  [CacheDirectory stringByAppendingPathComponent:fileName];
}

// 缓存是否过期
+ (BOOL)isCacheStale:(NSString *)fileName
{
    NSString *archivePath = [RESTFulEngine cacheFilePath:fileName];
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil]
                                      fileModificationDate] timeIntervalSinceNow];
    return abs(stalenessLevel) > 259200; // 4天为过期时间
}
@end
