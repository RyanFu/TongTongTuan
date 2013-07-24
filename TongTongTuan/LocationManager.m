//
//  LocationManager.m
//  TongTongTuan
//
//  李红(410139419@qq.com)创建于 13-7-23.
//  Copyright (c) 2013年 贵阳世纪恒通科技有限公司. All rights reserved.
//

#import "LocationManager.h"
#import "SIAlertView.h"
#import "RESTFulEngine.h"

@interface LocationManager()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, assign) BOOL isCompletedLocaation;
@end

@implementation LocationManager
- (id)init
{
    if(self = [super init])
    {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
    }
    
    return self;
}

- (void)startLocation
{
    self.isCompletedLocaation = NO;
    [self.manager startUpdatingLocation];
}


- (void)stopLocation
{
    [self.manager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    NSTimeInterval interval = [[newLocation timestamp] timeIntervalSinceNow];
    if(interval >= -30 && interval < 0)
    {
        [self stopLocation];
        if(self.isCompletedLocaation)
        {
            return;
        }
        self.isCompletedLocaation = YES;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if(error || placemarks.count == 0)
            {
                [SIAlertView showWithMessage:@"获取城市信息失败，请手动选择城市。" text1:@"关闭" okBlock:^{
                    if(self.delegate)
                    {
                        [self.delegate locationManagerFial];
                    }
                }];
            }else
            {
                CLPlacemark *placemark = placemarks[0];
                NSString *cityName = placemark.locality;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF==%@", cityName];
                [RESTFulEngine getCityListOnSuccess:^(NSMutableDictionary *dictionary) {
                    // 从城市列表中提取所有城市的名称放到数组citys中,然后用定位获取的城市名在citys中进行查找，以找到与定位获得的名称相同城市.
                    NSArray *keys = [dictionary allKeys];
                    NSMutableArray *citys = [NSMutableArray new];
                    for(NSString *key in keys)
                    {
                        NSArray *cityItems = dictionary[key];
                        for(NSDictionary *dic in cityItems)
                        {
                            [citys addObject:dic[@"areaname"]];
                        }
                    }
                    
                    NSArray *result = [citys filteredArrayUsingPredicate:predicate];
                    if(result.count > 0)
                    {
                        NSString *currentCityName = result[0];
                        NSString *messsage = [NSString stringWithFormat:@"GPS定位到您当前在%@，需要切换城市吗？", currentCityName];
                        [SIAlertView showWithTitle:@"提示" andMessage:messsage text1:@"不要" text2:@"切换" okBlock:^{
                           
                            BOOL found = NO;
                            for(NSString *key in keys)
                            {
                                if(found)
                                {
                                    break;
                                }
                                
                                NSArray *cityItems = dictionary[key];
                                for(NSDictionary *dic in cityItems)
                                {
                                    NSString *name = dic[@"areaname"];
                                    if([name isEqualToString:currentCityName])
                                    {
                                        if(self.delegate)
                                        {
                                            [self.delegate locationManagerSuccess:newLocation.coordinate cityDictionary:dic name:placemark.name];
                                        }
                                        
                                        found = YES;
                                        break;
                                    }
                                }
                            }
                        } cancelBlock:^{
                            if(self.delegate)
                            {
                                [self.delegate locationManagerFial];
                            }
                        }];
                    }else
                    {
                        [SIAlertView showWithMessage:@"未能找到您所在城市，请手动选择城市。" text1:@"关闭" okBlock:^{
                            if(self.delegate)
                            {
                                [self.delegate locationManagerFial];
                            }
                        }];
                    }
                    
                } onError:^(NSError *engineError) {
                    
                }];
            }
        }];
    }
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSString *errorMsg = nil;
    if([error code] == kCLErrorDenied)
    {
        errorMsg = @"请在[设置->隐私->定位服务]中开启定位功能";
    }else
    {
        errorMsg = @"定位失败，请手动选择城市。";
    }
    
    [SIAlertView showWithMessage:errorMsg text1:@"关闭" okBlock:^{
        if(self.delegate)
        {
            [self.delegate locationManagerFial];
        }
    }];
}
@end
