//
//  AppDelegate.m
//  TongTongTuan
//
//  Created by xcode on 13-7-15.
//  Copyright (c) 2013年 李红(410139419@qq.com). All rights reserved.
//

#import "AppDelegate.h"
#import "LHTabBarController.h"
#import "TuanGouController.h"
#import "ZhouBianController.h"
#import "UserProfileController.h"
#import "GengDuoController.h"
#import "RESTFulEngine.h"
#import "Crackify.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

    [RESTFulEngine getCityListOnSuccess:^(NSMutableDictionary *dictionary) {
    } onError:^(NSError *engineError) {
    }];
    
    TuanGouController *tuanGouController = [[TuanGouController alloc] init];
    self.tuanGouController = tuanGouController;
    ZhouBianController *zhouBianController = [[ZhouBianController alloc] init];
    UserProfileController *woDeController = [[UserProfileController alloc] initWithNibName:@"UserProfileController" bundle:nil];
    GengDuoController *gengDuoController = [[GengDuoController alloc] init];
    
    UINavigationController *nav1, *nav2, *nav3, *nav4;
    nav1 = [[UINavigationController alloc] initWithRootViewController:tuanGouController];
    nav2 = [[UINavigationController alloc] initWithRootViewController:zhouBianController];
    nav3 = [[UINavigationController alloc] initWithRootViewController:woDeController];
    nav4 = [[UINavigationController alloc] initWithRootViewController:gengDuoController];
    
    NSArray *normalIcons =
    @[@"tab_bar_tuan_gou_normal",@"tab_bar_zhou_bian_normal",@"tab_bar_wo_de_normal",@"tab_bar_geng_duo_normal"];
    NSArray *highlightIcons =
    @[@"tab_bar_tuan_gou_highlight",@"tab_bar_zhou_bian_highlight",@"tab_bar_wo_de_highlight",@"tab_bar_geng_duo_highlight"];
    LHTabBarController *tabBarController = [[LHTabBarController alloc] initWithViewControllers:@[nav1, nav2,nav3, nav4]
                                                                         tabBarNormalItemIcons:normalIcons
                                                                      tabBarHighlightItemIcons:highlightIcons
                                                               selectedItemBackgroundImageName:@"tab_bar_selected_item_background"
                                                                     tabBarBackgroundImageName:@"tab_bar_background"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"程序崩溃: %@", exception);
    NSLog(@"\n------------------------------------------------------------------\n调用栈:\n %@", [exception callStackSymbols]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
