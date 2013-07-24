//
//  BaseController.m
//  BaseIOSProject
//
//  Created by xcode on 13-7-1.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "BaseController.h"

@interface BaseController()

@property (nonatomic, strong) NSMutableArray *executingNetworkingOperations;
@property (nonatomic, strong) UIView *errorView, *loadingView;

- (void)showView:(UIView *)view animation:(BOOL)animation;
- (void)hideView:(UIView *)view animation:(BOOL)animation;

@end

@implementation BaseController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 当视图消失时取消视图控制器中正在执行的网络操作
    for(NSOperation *operation in self.executingNetworkingOperations)
    {
        if(operation.isExecuting)
        {
            [operation cancel];
            [self.executingNetworkingOperations removeObject:operation];
        }
    }
}


#pragma mark - ErrorView
- (UIView *)errorView
{
    return nil;
}


- (void)showErrorViewAnimation:(BOOL)animation
{
    [self showView:[self errorView] animation:animation];
}


- (void)hideErrorViewAnimation:(BOOL)animation
{
    [self hideView:[self errorView] animation:animation];
}


#pragma mark - LoadingView
- (UIView *)loadingView
{
    return nil;
}


- (void)showLoadingViewAnimation:(BOOL)animation
{
    [self showView:[self loadingView] animation:animation];
}


- (void)hideLoadingViewAnimation:(BOOL)animation
{
    [self hideView:[self loadingView] animation:animation];
}


#pragma mark - Networking Operation
- (NSMutableArray *)executingNetworkingOperations
{
    if(_executingNetworkingOperations)
    {
        return _executingNetworkingOperations;
    }
    
    _executingNetworkingOperations = [NSMutableArray new];
    return _executingNetworkingOperations;
}


- (void) saveExecutingNetworkingOperation:(NSOperation *)networkingOperation
{
    [self.executingNetworkingOperations addObject:networkingOperation];
}


#pragma mark - Private Method
- (void)showView:(UIView *)view animation:(BOOL)animation
{
    if(view == nil)
    {
        return;
    }
    
    view.alpha = 0.0;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    NSTimeInterval duration = animation ? 0.5 : 0.0;
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 1.0;
    }];
}


- (void)hideView:(UIView *)view animation:(BOOL)animation
{
    if(view == nil)
    {
        return;
    }
    
    NSTimeInterval duration = animation ? 0.5 : 0.0;
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}


@end
