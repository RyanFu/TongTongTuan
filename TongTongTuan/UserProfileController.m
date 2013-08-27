//
//  UserProfileController.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-27.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "UserProfileController.h"
#import "FXKeychain+User.h"
#import "UserLoginController.h"

@interface UserProfileController ()<UITableViewDataSource,UITableViewDelegate>
// 头部
@property (weak, nonatomic) IBOutlet UILabel *userNicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteProductCountLabel;
@property (weak, nonatomic) IBOutlet UIView *loginedView;
@property (weak, nonatomic) IBOutlet UIView *unloginView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserProfileController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.headerView;
    
    [FXKeychain userLogout];
    if([FXKeychain isUserLogin]){
        self.loginedView.hidden = NO;
        self.unloginView.hidden = YES;
    }else{
        self.loginedView.hidden = YES;
        self.unloginView.hidden = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setUserNicknameLabel:nil];
    [self setAccountBalanceLabel:nil];
    [self setCouponCountLabel:nil];
    [self setFavoriteProductCountLabel:nil];
    [self setLoginedView:nil];
    [self setUnloginView:nil];
    [self setHeaderView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}


#pragma mark - Action

- (IBAction)showUserLoginView:(id)sender
{
    UserLoginController *ULC = [[UserLoginController alloc] initWithNibName:@"UserLoginController" bundle:nil];
    [self.navigationController presentModalViewController:ULC animated:YES];
    ULC.loginBlock = ^(BOOL flag){
        if(flag){
            self.loginedView.hidden = NO;
            self.unloginView.hidden = YES;
        }
    };
}

- (IBAction)showCouponList:(id)sender
{
    
}

- (IBAction)showFavoriteProductList:(id)sender
{
    
}

#pragma mark - 表数据源和代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
