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
#import "AppDelegate.h"
#import "RESTFulEngine.h"
#import "UserAccountSettingController.h"

//18685050539
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
    [self updateUI];
}

- (void)updateUI
{
    if([FXKeychain isUserLogin]){  // 用户已登陆
        self.loginedView.hidden = NO;
        self.unloginView.hidden = YES;
        
        // 获取用户信息
        [RESTFulEngine getUserInfoOnSuccess:^{
            UserInfo *userInfo = GetUserInfo();
            if(!userInfo){
                return;
            }
            
            self.userNicknameLabel.text = userInfo.username;
            self.accountBalanceLabel.text = [NSString stringWithFormat:@"账户余额: %.1f元", userInfo.account_balance];
            self.favoriteProductCountLabel.text  = [NSString stringWithFormat:@"%d", userInfo.collectionnum];
            self.couponCountLabel.text = [NSString stringWithFormat:@"%d", userInfo.vouchersnum];
            
            [self.tableView reloadData];
            
        } onError:^(NSError *engineError) {
            NSLog(@"获取用户信息失败");
        }];
    }else{
        self.loginedView.hidden = YES;
        self.unloginView.hidden = NO;
        [self.tableView reloadData];
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
        if(flag){  // 用户登陆成功
            [self updateUI];
        }
    };
}

- (IBAction)showUserAccountSettingView:(id)sender
{
    UserAccountSettingController *UASC =
    [[UserAccountSettingController alloc] initWithNibName:@"UserAccountSettingController" bundle:nil];
    [self.navigationController pushViewController:UASC animated:YES];
    UASC.userLogoutBlock = ^(){  // 用户退出登陆
        [self updateUI];
    };
}

- (IBAction)showCouponList:(id)sender
{
    
}

- (IBAction)showFavoriteProductList:(id)sender
{
    
}

#pragma mark - 表数据源和代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSString *imageName, *text, *detailText;
    UserInfo *userInfo = GetUserInfo();
    switch(indexPath.section){
        case 0:{
            imageName = @"tab_bar_zhou_bian_normal";
            text = @"最近浏览";
            detailText = @"10";
            break;
        }
            
        case 1:{
            switch(indexPath.row){
                case 0:{
                    imageName = @"tab_bar_zhou_bian_normal";
                    text = @"待付款订单";
                    detailText = [NSString stringWithFormat:@"%d", userInfo.order_payment_no];
                    break;
                }
                    
                case 1:{
                    imageName = @"tab_bar_zhou_bian_normal";
                    text = @"已付款订单";
                    detailText = [NSString stringWithFormat:@"%d", userInfo.order_payment_ok];
                    break;
                }
                    
                case 2:{
                    imageName = @"tab_bar_zhou_bian_normal";
                    text = @"优惠劵订单";
                    detailText = [NSString stringWithFormat:@"%d", userInfo.order_coupon];
                    break;
                }
                    
                case 3:{
                    imageName = @"tab_bar_zhou_bian_normal";
                    text = @"抽奖单";
                    detailText = [NSString stringWithFormat:@"%d", userInfo.order_lottery];
                    break;
                }
                default:break;
            }
        }
        default:break;
    }

    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = text;
    if([FXKeychain isUserLogin]){
        cell.detailTextLabel.text = detailText;
    }else{
        cell.detailTextLabel.text = nil;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section  == 0 ? 0 : 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    view.backgroundColor = UIColor.clearColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, section ? 0 : 30)];
    view.backgroundColor = UIColor.clearColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([FXKeychain isUserLogin]){
        
    }else{
        [self showUserLoginView:nil];
    }
}
@end
