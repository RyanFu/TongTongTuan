//
//  LHNavigationController.h
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-16.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LHNavigationControllerCompletionBlock)(void);

@interface LHNavigationController : UIViewController<UIGestureRecognizerDelegate>
{
    @private
    NSMutableArray *_gestures;
    UIView         *_blackMask;
    CGPoint        _panOrigin;
    BOOL           _animationInProgress;
    CGFloat        _percentageOffsetFromLeft;
}

@property(nonatomic, retain) NSMutableArray *viewControllers;

- (id) initWithRootViewController:(UIViewController*)rootViewController;

- (void) pushViewController:(UIViewController *)viewController;
- (void) pushViewController:(UIViewController *)viewController completion:(LHNavigationControllerCompletionBlock)handler;
- (void) popViewController;
- (void) popViewControllerWithCompletion:(LHNavigationControllerCompletionBlock)handler;

@end


@interface UIViewController (LHNavigationController)
@property (nonatomic, retain) LHNavigationController *lhNavigationController;
@end