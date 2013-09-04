//
//  UserAccountSettingController.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-28.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "UserAccountSettingController.h"
#import "AppDelegate.h"
#import "FXKeychain+User.h"
#import "ResetUserPasswordController.h"
#import "ShippingAddressList.h"
#import "NewShippingAddress.h"

@interface UserAccountSettingController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UserAccountSettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的账户";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 退出登陆
- (IBAction)userLogout:(id)sender
{
    [FXKeychain userLogout];
    if(self.userLogoutBlock){
        self.userLogoutBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *imageName, *text, *detailText;
    UserInfo *userInfo = GetUserInfo();
    
    switch(indexPath.row){
        case 0:{
            imageName = @"tab_bar_zhou_bian_normal";
            text = userInfo.username;
            break;
        }
            
        case 1:{
            imageName = @"tab_bar_zhou_bian_normal";
            text = @"修改密码";
            break;
        }
            
        case 2:{
            imageName = @"tab_bar_zhou_bian_normal";
            text = @"绑定手机";
            detailText = userInfo.phoneno;
            break;
        }
            
        case 3:{
            imageName = @"tab_bar_zhou_bian_normal";
            text = @"收货地址";
            break;
        }
        default:break;
    }
    
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(indexPath.row){
        case 0:{
     
            break;
        }
            
        case 1:{
            ResetUserPasswordController *RUPC =
            [[ResetUserPasswordController alloc] initWithNibName:@"ResetUserPasswordController" bundle:nil];
            [self.navigationController pushViewController:RUPC animated:YES];
            break;
        }
            
        case 2:{
         
            break;
        }
            
        case 3:{
            NewShippingAddress *NSA =
            [[NewShippingAddress alloc] initWithNibName:@"NewShippingAddress" bundle:nil];
            [self.navigationController pushViewController:NSA animated:YES];
            break;
        }
        default:break;
    }

}
@end
