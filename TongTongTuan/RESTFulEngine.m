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

#define kHost @"192.168.1.198"
#define kProductTypeDataFile @"product_type_data.plist"

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

+ (MKNetworkOperation *)getProductTypeOnSuccess:(ArrayBlock)onSuccess onError:(ErrorBlock)onError
{
    NSMutableArray *modelDataArray = [NSMutableArray arrayWithContentsOfFile:[RESTFulEngine cacheFilePath:kProductTypeDataFile]];
    // 若有缓存数据并且数据没有过期则使用缓存数据
    if(modelDataArray && [RESTFulEngine isCacheStale:kProductTypeDataFile] == NO)
    {
        onSuccess(modelDataArray);
        return nil;
    }else
    {
        RESTFulEngine *engine = [RESTFulEngine shareInstance];
        MKNetworkOperation *operation = [engine operationWithPath:@"ProService/GetProType/1"];
        [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSArray *josnArray = [completedOperation responseJSON];
            if([josnArray writeToFile:[RESTFulEngine cacheFilePath:kProductTypeDataFile] atomically:YES] == NO)
            {
                NSLog(@"保存产品类别数据失败");
            }
            
            NSMutableArray *modelArray = [NSMutableArray new];
            for(NSMutableDictionary *dic in josnArray)
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


+ (NSString *)cacheFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (BOOL)isCacheStale:(NSString *)fileName
{
    NSString *archivePath = [RESTFulEngine cacheFilePath:fileName];
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil]
                                      fileModificationDate] timeIntervalSinceNow];
    return abs(stalenessLevel) > 259200; // 4天为过期时间
}
@end
