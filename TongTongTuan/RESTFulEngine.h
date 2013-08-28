//
//  RESTFulEngine.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-18.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "JSONModel.h"
#import <CoreLocation/CoreLocation.h>
#import "Product.h"
#import "Order.h"
#import "Defines.h"
#import "ProductType.h"
#import "Menu.h"
#import "City.h"
#import "Utilities.h"
#import "ServerReturnValue.h"
#import "UserLoginInfo.h"

typedef void (^VoidBlock) (void);
typedef void (^ModelBlock) (JSONModel* aModelBaseObject);
typedef void (^ArrayBlock) (NSMutableArray* listOfModelBaseObjects);
typedef void (^DictionaryBlock)(NSMutableDictionary *dictionary);
typedef void (^ErrorBlock) (NSError* engineError);

@interface RESTFulEngine : MKNetworkEngine
+ (RESTFulEngine *)shareInstance;

+ (MKNetworkOperation *)getProductTypeOnSuccess:(ArrayBlock)onSuccess
                                        onError:(ErrorBlock)onError;

+ (MKNetworkOperation *)getMenuOnSuccess:(ArrayBlock)onSuccess
                                 onError:(ErrorBlock)onError;

+ (MKNetworkOperation *)getCityListOnSuccess:(DictionaryBlock)onSuccess
                                     onError:(ErrorBlock)onError;

// 获取商品列表，参数含义可参看接口文档
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
                                                      onError:(ErrorBlock)onError;

// 搜索商品
+ (MKNetworkOperation *)searchProductWithKeyword:(NSString *)keyword
                                       onSuccess:(ArrayBlock)onSuccess
                                         onError:(ErrorBlock)onError;

// 获取商品(商品详情)
+ (MKNetworkOperation *)getProductDetail:(Product *)product
                               onSuccess:(ModelBlock)onSuccess
                                 onError:(ErrorBlock)onError;

// 获取收藏的商品
+ (MKNetworkOperation *)getMyFavoriteProductByUserName:(NSString *)userName
                                             onSuccess:(ArrayBlock)onSuccess
                                               onError:(ErrorBlock)onError;

// 收藏商品
+ (MKNetworkOperation *)saveMyFavoriteProductByProductId:(NSInteger)productId
                                            andUserName:(NSString *)userName
                                              onSuccess:(ModelBlock)onSuccess
                                                onError:(ErrorBlock)onError;

// 提交订单
+ (MKNetworkOperation *)submitOrder:(Order *)order
                          onSuccess:(ModelBlock)onSuccess
                            onError:(ErrorBlock)onError;


// 用户登陆
+ (MKNetworkOperation *)userLoginWithUserName:(NSString *)userName
                                  andPassword:(NSString *)password
                                    onSuccess:(ModelBlock)onSuccess
                                      onError:(ErrorBlock)onError;

// 获取已登陆用户的用户信息
// 在用户修改密码后，应该退出登陆，否则调用此方法获取用户信息会导致获取失败
// 此方法在成功获取用户信息后，会通过SetUserInfo()宏保存用户信息
+ (void)getUserInfoOnSuccess:(VoidBlock)onSuccess
                     onError:(ErrorBlock)onError;

// 用户注册
+ (MKNetworkOperation *)newUserRegisterWithPhoneNumber:(NSString *)phoneNumber
                                           andPassword:(NSString *)password
                                             onSuccess:(ModelBlock)onSuccess
                                               onError:(ErrorBlock)onError;

// 重置密码
+ (MKNetworkOperation *)resetUserPasswordWithUserAccount:(NSString *)userAccount
                                           andPasword:(NSString *)password
                                            onSuccess:(ModelBlock)onSuccess
                                              onError:(ErrorBlock)onError;

// 获取验证码
// @registerStatus 注册状态 0不检查是否注册 1检查是否注册，根据状态不同，返回的Message不同
+ (MKNetworkOperation *)getVCodeWithPhoneNumber:(NSString *)phoneNumber
                                 registerStatus:(NSInteger)status
                                      onSuccess:(ModelBlock)onSuccess
                                        onError:(ErrorBlock)onError;

// 缓存文件路径
+ (NSString *)cacheFilePath:(NSString *)fileName;
@end
