//
//  UserLoginController.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-27.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "UserLoginController.h"
#import "FXKeychain+User.h"
#import "RESTFulEngine.h"
#import "UserInfoValidator.h"
#import "SIAlertView.h"
#import "Utilities.h"

@interface UserLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@end

@implementation UserLoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

// 关闭视图
- (IBAction)dismiss:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

// 显示找回密码界面
- (IBAction)showRetrievePasswordView:(id)sender
{
    
}

// 执行登陆操作
- (IBAction)userLogin:(id)sender
{
    NSString *userName = nil, *userPasword = nil;
    userName = self.userNameTextField.text;
    userPasword = self.userPasswordTextField.text;
    
    if(userName.length == 0 || userPasword.length == 0){
        [SIAlertView showWithMessage:@"账号或密码不能为空" text1:@"关闭" okBlock:^{}];
        return;
    }
    
    [self.view endEditing:YES];
    
#pragma makr - 登陆等待
    [RESTFulEngine userLoginWithUserName:userName
                             andPassword:userPasword
                               onSuccess:^(JSONModel *aModelBaseObject) {
                                   UserLoginInfo *v = (UserLoginInfo *)aModelBaseObject;
                                   if(v.result == YES){ // 登陆成功
                                       [FXKeychain saveUserAccount:userName andPassword:userPasword];
                                       [Utilities saveUserInfo:v.CustomerInfo];
                                       self.loginBlock(YES);
                                       [self dismiss:nil];
                                   }else{
                                       NSString *message = [NSString stringWithFormat:@"登陆失败,原因:%@",v.message];
                                       [SIAlertView showWithMessage:message text1:@"关闭" okBlock:^{}];
                                   }
    } onError:^(NSError *engineError) {
        NSString *message = [NSString stringWithFormat:@"登陆失败,原因:%@",[engineError localizedDescription]];
        [SIAlertView showWithMessage:message text1:@"关闭" okBlock:^{}];
    }];
}
- (void)viewDidUnload {
    [self setUserNameTextField:nil];
    [self setUserPasswordTextField:nil];
    [super viewDidUnload];
}
@end
