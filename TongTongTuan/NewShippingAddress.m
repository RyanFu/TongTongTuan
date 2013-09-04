//
//  NewShippingAddress.m
//  TongTongTuan
//
//  Created by 李红 on 13-9-3.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "NewShippingAddress.h"
#import "RESTFulEngine.h"
#import "UserInfoValidator.h"
#import "SIAlertView.h"
#import "RESTFulEngine.h"
#import "SIAlertView.h"
#import "UIScrollView+ContentSize.h"
#import "AppDelegate.h"

static const CGFloat animationDuration = 0.3;

@interface NewShippingAddress ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextField;
@property (weak, nonatomic) IBOutlet UITextView  *streetAddressTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *pickerViewContainer;

@property (strong, nonatomic) NSArray *pickerViewDataSource;
@property (assign,nonatomic) BOOL defaultAddress, pickerViewIsShowing;
@property (copy, nonatomic) NSString *province, *city, *zone, *pcode, *ccode, *zcode;
@end

@implementation NewShippingAddress

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
    
    self.defaultAddress = YES;
    self.pickerViewIsShowing = NO;
    
    [UIScrollView setScrollViewContentSize:self.scrollView];
    
    CGRect bounds = self.view.bounds;
    CGRect frame = self.pickerViewContainer.frame;
    frame.origin.y = bounds.size.height;
    self.pickerViewContainer.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setPhoneNumberTextField:nil];
    [self setZipcodeTextField:nil];
    [self setStreetAddressTextView:nil];
    [self setScrollView:nil];
    [self setAddressTextField:nil];
    [self setPickerView:nil];
    [self setPickerViewContainer:nil];
    [super viewDidUnload];
}

#pragma mark Action

- (IBAction)tapOnScrollView:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    [self hidePickerView:nil];
}

- (IBAction)hidePickerView:(UIBarButtonItem *)sender
{
    if(self.pickerViewIsShowing){
        [UIView animateWithDuration:animationDuration animations:^{
            CGRect bounds = self.view.bounds;
            CGRect frame = self.pickerViewContainer.frame;
            frame.origin.y = bounds.size.height;
            self.pickerViewContainer.frame = frame;
        } completion:^(BOOL finished) {
            self.pickerViewIsShowing = NO;
        }];
    }
}

- (IBAction)completedSelecte:(id)sender
{
    [self hidePickerView:nil];
    
    NSInteger row1, row2, row3;
    row1 = [self.pickerView selectedRowInComponent:0];
    row2 = [self.pickerView selectedRowInComponent:1];
    row3 = [self.pickerView selectedRowInComponent:2];
    
    self.province = @"", self.city = @"", self.zone = @"";
    self.pcode = @"", self.ccode = @"", self.zcode = @"";
    
    NSDictionary *dict1 = self.pickerViewDataSource[row1];
    self.province = dict1[@"areaname"];
    self.pcode = dict1[@"areacode"];
    
    NSArray *array1 = [dict1 valueForKey:@"childrencitys"];
    if(array1 && array1.count){
        NSDictionary *dict2 = array1[row2];
        self.city = dict2[@"areaname"];
        self.ccode = dict2[@"areacode"];
        
        NSArray *array2 = [dict2 valueForKey:@"childrencitys"];
        if(array2 && array2.count){
            NSDictionary *dict3 = array2[row3];
            self.zone = dict3[@"areaname"];
            self.zcode = dict3[@"areacode"];
        }
    }
    
    self.addressTextField.text = [NSString stringWithFormat:@"%@%@%@",self.province,self.city,self.zone];
}

- (IBAction)usingAsDefaultAddress:(id)sender
{
    self.defaultAddress = !self.defaultAddress;
}

- (IBAction)saveNewShippingAddress:(id)sender
{
    NSString *name, *phoneNumber, *zipcode, *address, *streetAddress;
    name = self.nameTextField.text;
    phoneNumber = self.phoneNumberTextField.text;
    zipcode = self.zipcodeTextField.text;
    address = self.addressTextField.text;
    streetAddress = self.streetAddressTextView.text;
    
    if(name.length < 2){
        [SIAlertView showWithMessage:@"姓名不能少于2个字" text1:@"关闭" okBlock:^{}];
        return;
    }
    
    if([UserInfoValidator isValidMobileNumber:phoneNumber] == NO){
        [SIAlertView showWithMessage:@"请填写合法的手机号码" text1:@"关闭" okBlock:^{}];
        return;
    }
    
    if([UserInfoValidator isValidZipCode:zipcode] == NO){
        [SIAlertView showWithMessage:@"请填写合法的邮政编码" text1:@"关闭" okBlock:^{}];
        return;
    }
    
    if(address.length == 0){
        [SIAlertView showWithMessage:@"请选择省市，不少6个字" text1:@"" okBlock:^{}];
        return;
    }
    
    if(streetAddress.length == 0){
        [SIAlertView showWithMessage:@"请填写详细地址" text1:@"" okBlock:^{}];
        return;
    }
    
    UserInfo *userInfo = GetUserInfo();
    
    Logistics *l = [[Logistics alloc] init];
    l.recive_address = [NSString stringWithFormat:@"%@%@", address,streetAddress];
    l.recive_province = self.pcode;
    l.recive_city = self.ccode;
    l.recive_district = self.zcode;
    l.recive_man = name;
    l.recive_postcode = zipcode.integerValue;
    l.recive_phone = phoneNumber;
    l.isdefault = self.defaultAddress;
    l.sys_customer_id = userInfo.uid;
    
#warning  给出等待提示
    [RESTFulEngine addNewShippingAddress:l onSuccess:^(JSONModel *aModelBaseObject) {
        ServerReturnValue *rv = (ServerReturnValue *)aModelBaseObject;
        if(rv.result){
            NSLog(@"添加成功");
        }else{
            NSLog(@"添加失败 %@", rv.message);
        }
    } onError:^(NSError *engineError) {
    }];
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [RESTFulEngine getAreaData:^(NSMutableArray *listOfModelBaseObjects) {
        self.pickerViewDataSource = listOfModelBaseObjects;
        [self.pickerView reloadAllComponents];
        NSLog(@"%@", self.pickerViewDataSource);
        if(self.pickerViewIsShowing == NO){
            [UIView animateWithDuration:animationDuration animations:^{
                CGRect bounds = self.view.bounds;
                CGRect f = self.pickerViewContainer.frame;
                f.origin.y = bounds.size.height - f.size.height;
                self.pickerViewContainer.frame = f;
            } completion:^(BOOL finished) {
                self.pickerViewIsShowing = YES;
            }];
        }
    } onError:^(NSError *engineError) {
        [SIAlertView showWithTitle:@"提示" andMessage:@"获取省市数据失败" text1:@"重试" text2:@"关闭" okBlock:^{
            [self textFieldShouldBeginEditing:nil];
        } cancelBlock:^{}];
    }];
    
    return NO;
}

#pragma mark - UIPickerViewDataSource And UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(self.pickerViewDataSource == nil && self.pickerViewDataSource.count == 0){
        return 0;
    }
    
    NSInteger row = 0;
    
    switch (component){
        case 0:
        {
            row = self.pickerViewDataSource.count;
            break;
        }
            
        case 1:
        {
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            NSDictionary *dic = self.pickerViewDataSource[selectedRow];
            NSArray *array = [dic valueForKey:@"childrencitys"];
            NSAssert(array, @"找到不到指定Key的值");
            // 服务器在返回空数组的时候会错误的返回childrencitys:"null"形式的值，
            // 这时客户端会将null解析为NSNull对象,也就是array会指向一个NSNull对象，这是后调用count
            // 方法就会导致程序崩溃,所以这里需要处理异常
            @try {
                row = array.count;
            }
            @catch (NSException *exception) {
                LHException(exception);
            }
            
            break;
        }
            
        case 2:
        {
            NSInteger selectedRow1 = [pickerView selectedRowInComponent:0];
            NSInteger selectedRow2 = [pickerView selectedRowInComponent:1];
            NSDictionary *dic1 = self.pickerViewDataSource[selectedRow1];
            NSArray *array1 = [dic1 valueForKey:@"childrencitys"];
            NSAssert(array1, @"找到不到指定Key的值");
            @try {
                if(array1.count){
                    NSDictionary *dic2 = array1[selectedRow2];
                    NSArray *array2 = [dic2 valueForKey:@"childrencitys"];
                    NSAssert(array2, @"找到不到指定Key的值");
                    row = array2.count;
                }
            }
            @catch (NSException *exception) {
                LHException(exception);
            }
           
            break;
        }
        default:break;
    }
    
    return row;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    NSInteger selectedRow1 = [pickerView selectedRowInComponent:0];
    NSInteger selectedRow2 = [pickerView selectedRowInComponent:1];
    
    switch (component){
        case 0:
        {
            NSDictionary *dic = self.pickerViewDataSource[row];
            title = dic[@"areaname"];
            break;
        }
            
        case 1:
        {
            NSDictionary *dic1 = self.pickerViewDataSource[selectedRow1];
            NSArray *array = [dic1 valueForKey:@"childrencitys"];
            NSAssert(array, @"找到不到指定Key的值");
            @try {
                if(array.count){
                    NSDictionary *dic2 = array[row];
                    title = dic2[@"areaname"];
                }
            }
            @catch (NSException *exception) {
                LHException(exception);
            }
            break;
        }
            
        case 2:
        {
            NSDictionary *dic1 = self.pickerViewDataSource[selectedRow1];
            NSArray *array1 = [dic1 valueForKey:@"childrencitys"];
            NSAssert(array1, @"找到不到指定Key的值");
            @try {
                if(array1.count){
                    NSDictionary *dic2 = array1[selectedRow2];
                    NSArray *array2 = [dic2 valueForKey:@"childrencitys"];
                    NSAssert(array2, @"找到不到指定Key的值");
                    if(array2.count){
                        NSDictionary *dic3 = array2[row];
                        title = dic3[@"areaname"];
                    }
                }
            }
            @catch (NSException *exception) {
                LHException(exception);
            }
            
            break;
        }
        default:break;
    }

    
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{    
    if(component == 0){
        NSDictionary *dic = self.pickerViewDataSource[row];
        self.province = [dic valueForKey:@"areaname"];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }else if(component == 1){
        
        [pickerView reloadComponent:2];
    }else{
    }
    
}
@end
