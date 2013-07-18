//
//  RESTFulEngine.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-18.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "JSONModel.h"

typedef void (^VoidBlock) (void);
typedef void (^ModelBlock) (JSONModel* aModelBaseObject);
typedef void (^ArrayBlock) (NSMutableArray* listOfModelBaseObjects);
typedef void (^ErrorBlock) (NSError* engineError);

@interface RESTFulEngine : MKNetworkEngine
+ (RESTFulEngine *)shareInstance;

+ (MKNetworkOperation *)getProductTypeOnSuccess:(ArrayBlock)onSuccess onError:(ErrorBlock)onError;

+ (NSString *)cacheFilePath:(NSString *)fileName;
@end
