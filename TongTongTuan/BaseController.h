//
//  BaseController.h
//  BaseIOSProject
//
//  Created by xcode on 13-7-1.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController

#pragma mark - ErrorView
/* 提供显示错误信息的视图，默认返回nil。
 * 子类可以重写这个方法来提供自定义视图或者修改默认返回值来提供统一的错误信息视图。
 */
- (UIView *)errorView;
- (void)showErrorViewAnimation:(BOOL)animation;
- (void)hideErrorViewAnimation:(BOOL)animation;

#pragma mark - LoadingView
- (UIView *)loadingView;
- (void)showLoadingViewAnimation:(BOOL)animation;
- (void)hideLoadingViewAnimation:(BOOL)animation;

#pragma mark - Networking Operation 
- (void) saveExecutingNetworkingOperation:(NSOperation *)networkingOperation;

@end
