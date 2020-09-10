//
//  SCShoppingManager.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCLocationService.h"
#import <CoreLocation/CoreLocation.h>
#import "SCShoppingManager.h"

#define SC_LAT_OFFSET_0(x,y) -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
#define SC_LAT_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define SC_LAT_OFFSET_2 (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
#define SC_LAT_OFFSET_3 (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0

#define SC_LON_OFFSET_0(x,y) 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
#define SC_LON_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define SC_LON_OFFSET_2 (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
#define SC_LON_OFFSET_3 (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0

#define SC_jzA 6378245.0
#define SC_jzEE 0.00669342162296594323


@interface SCLocationService()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
// 地理位置解码编码器
@property (nonatomic,retain) CLGeocoder *geocoder;

@property (nonatomic, copy, nullable) SCLocationBlock locationBlock;

@end

@implementation SCLocationService
DEF_SINGLETON(SCLocationService)

- (void)startLocation:(SCLocationBlock)callBack;
{
    self.locationBlock = callBack;

    if (VALID_STRING(self.longitude) && VALID_STRING(self.latitude)) {
        [self callBack];
        return;
    }
    
    //从掌厅获取定位
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    if (VALID_DICTIONARY(manager.locationInfo)) {
        self.longitude = NSStringFormat(@"%@", manager.locationInfo[@"longitude"]);
        self.latitude  = NSStringFormat(@"%@", manager.locationInfo[@"latitude"]);
        self.cityCode  = NSStringFormat(@"%@", manager.locationInfo[@"cityCode"]);
        self.city      = NSStringFormat(@"%@", manager.locationInfo[@"City"]);
        [self callBack];
        return;
    }
    
    //代理没有获取到则本地获取
    [self startLocation];
}


//开始定位
- (void)startLocation
{
    //     判断定位服务是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        [self callBack];
        return;
    }
    
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    //    定位精度（根据项目的要求来选择，精确越高，耗电量越大）
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //    距离过滤（触发定位代理的方法）
    self.locationManager.distanceFilter = 50.0f;
    //    iOS8新方法
    if (iOS8Later)
    {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        //            [_locationManager requestAlwaysAuthorization];
    }
    //    开启定位
    [self.locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D wgsPt = location.coordinate;
    CLLocationCoordinate2D gcjPt = [SCLocationService gcj02Encrypt:wgsPt.latitude bdLon:wgsPt.longitude];
    
    self.longitude = NSStringFormat(@"%f",gcjPt.longitude);
    self.latitude  = NSStringFormat(@"%f",gcjPt.latitude);
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = placemarks.firstObject;
        NSString *city = mark.addressDictionary[@"City"];
        self.city = city;
    }];
    
    [self callBack];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self callBack];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            [self callBack];
            [self.locationManager stopUpdatingLocation];
        }
            break;
            
        default:
            break;
    }
}

- (void)callBack
{
    if (_locationBlock) {
        _locationBlock(self.longitude, self.latitude);
        _locationBlock = nil;
    }
}

- (void)cleanData
{
    _longitude = nil;
    _latitude  = nil;
    _cityCode  = nil;
    _city      = nil;
}

+ (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon
{
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self outOfChina:ggLat bdLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0)bdLon:(ggLat - 35.0)];
    double dLon = [self transformLon:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - SC_jzEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((SC_jzA * (1 - SC_jzEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (SC_jzA / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}

+ (BOOL)outOfChina:(double)lat bdLon:(double)lon
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

+ (double)transformLat:(double)x bdLon:(double)y
{
    double ret = SC_LAT_OFFSET_0(x, y);
    ret += SC_LAT_OFFSET_1;
    ret += SC_LAT_OFFSET_2;
    ret += SC_LAT_OFFSET_3;
    return ret;
}

+ (double)transformLon:(double)x bdLon:(double)y
{
    double ret = SC_LON_OFFSET_0(x, y);
    ret += SC_LON_OFFSET_1;
    ret += SC_LON_OFFSET_2;
    ret += SC_LON_OFFSET_3;
    return ret;
}

@end
