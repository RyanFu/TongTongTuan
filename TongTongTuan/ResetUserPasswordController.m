//
//  ResetUserPasswordController.m
//  TongTongTuan
//
//  Created by 李红 on 13-8-28.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "ResetUserPasswordController.h"
#import "FXKeychain+User.h"
#import "RESTFulEngine.h"
#import "UserInfoValidator.h"
#import "SIAlertView.h"

@interface ResetUserPasswordController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatNewPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *resetUserPasswordButton;
@end

@implementation ResetUserPasswordController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"修改密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.resetUserPasswordButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCurrentPasswordTextField:nil];
    [self setNPasswordTextField:nil];
    [self setRepeatNewPasswordTextField:nil];
    [self setResetUserPasswordButton:nil];
    [super viewDidUnload];
}

- (IBAction)handelPressedDoneKeyEvent:(UITextField *)sender
{
    [self resetUserPassword:nil];
}

- (IBAction)resetUserPassword:(id)sender
{
    NSString *currentPassword, *newPassword, *repeateNewPassword;
    
    currentPassword = self.currentPasswordTextField.text;
    newPassword = self.nPasswordTextField.text;
    repeateNewPassword = self.repeatNewPasswordTextField.text;
    
    if(currentPassword.length < 6){
        [SIAlertView showWithMessage:@"至少输入6位长度的当前密码" text1:@"关闭" okBlock:^{}];
        return;
    }
    
    if(newPassword.length < 6){
        [SIAlertView showWithMessage:@"至少输入6位长度的新密码" text1:@"关闭" okBlock:^{}];
        return;
    }

    if([newPassword isEqualToString:repeateNewPassword] == NO){
        [SIAlertView showWithMessage:@"两次输入新密码不一致" text1:@"关闭" okBlock:^{}];
        return;
    }

    if([newPassword isEqualToString:currentPassword] == YES){
        [SIAlertView showWithMessage:@"您曾经使用过这个密码，为了账号安全，请重新设置密码" text1:@"关闭" okBlock:^{}];
        return;
    }

#warning 重置密码等待提示
    [RESTFulEngine resetUserPasswordWithUserAccount:[FXKeychain userAccount]
                                         andPasword:[FXKeychain userPassword]
                                          onSuccess:^(JSONModel *aModelBaseObject) {
          ServerReturnValue *srv = (ServerReturnValue *)aModelBaseObject;
          if(srv.result){
              [self.navigationController popViewControllerAnimated:YES];
          }else{
              NSString *reason =
              [NSString stringWithFormat:@"重置密码失败,原因:%@", srv.message];
              [SIAlertView showWithMessage:reason text1:@"关闭" okBlock:^{}];
          }
    } onError:^(NSError *engineError) {
        NSString *reason =
        [NSString stringWithFormat:@"重置密码失败,原因:%@", [engineError localizedDescription]];
        [SIAlertView showWithMessage:reason text1:@"关闭" okBlock:^{}];
    }];
}


@end
