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

typedef NS_ENUM(NSInteger, SCLocationStatus) {
    SCLocationStatusNone,
    SCLocationStatusDoing,
    SCLocationStatusFinish
};

static NSDictionary *kCityCodeDict;


@interface SCLocationService()<CLLocationManagerDelegate>

@property (nonatomic, assign) SCLocationStatus status;

@property (nonatomic, strong) CLLocationManager *locationManager;
// 地理位置解码编码器
@property (nonatomic,retain) CLGeocoder *geocoder;

//@property (nonatomic, copy, nullable) SCLocationBlock locationBlock;
@property (nonatomic, strong) NSMutableArray <SCLocationBlock> *blockList;

@end

@implementation SCLocationService

@synthesize city = _city;

+ (void)initialize
{
    kCityCodeDict = @{@"南京": @"14",
                      @"苏州": @"11",
                      @"无锡": @"19",
                      @"常州": @"17",
                      @"南通": @"20",
                      @"镇江": @"18",
                      @"扬州": @"23",
                      @"泰州": @"21",
                      @"徐州": @"16",
                      @"盐城": @"22",
                      @"淮安": @"12",
                      @"连云港": @"15",
                      @"宿迁": @"13"};
}

+ (instancetype)sharedInstance
{
    static SCLocationService *_s;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s = [SCLocationService new];
    });
    return _s;
}

#pragma mark - public
- (void)startLocation:(SCLocationBlock)callBack
{
    [self startLocation:callBack useCache:YES];
}

- (void)startLocation:(SCLocationBlock)callBack useCache:(BOOL)useCache;
{
    if (useCache && self.status == SCLocationStatusFinish) {
        if (callBack) {
            callBack(self);
        }
        return;
    }
    
    //不用缓存或者没有缓存则开始定位
    if (callBack) {
        [self.blockList addObject:callBack];
    }
    
    [self startLocation];
}

#pragma mark -开始定位
- (void)startLocation
{
    if (_status == SCLocationStatusDoing) {
        return;
    }
    
    _status = SCLocationStatusDoing;
    
    //判断定位服务是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        [self stopLocation];
        return;
    }

    //    开启定位
    [self.locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D gcjPt = [SCLocationService gcj02Encrypt:location.coordinate];
    
    self.longitude = NSStringFormat(@"%f",gcjPt.longitude);
    self.latitude  = NSStringFormat(@"%f",gcjPt.latitude);
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count > 0) {
            CLPlacemark *mark = placemarks.firstObject;
            NSDictionary *addressDictionary = mark.addressDictionary;
            
            //城市
            NSString *city = addressDictionary[@"City"];
            self.city = city;
            
            //城市编码
            self.cityCode = kCityCodeDict[self.city];

            //详细地址
            NSString *state       = addressDictionary[@"State"];
            NSString *subLocality = addressDictionary[@"SubLocality"];
            NSString *street      = addressDictionary[@"Street"];
            NSString *name        = addressDictionary[@"Name"];
            
            NSString *locationAddress = [NSString stringWithFormat:@"%@%@%@%@%@",state,city,subLocality,street,name];
            self.locationAddress = locationAddress;
        }

        [self stopLocation];
        
    }];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            [self stopLocation];
        }
            break;
            
        default:
            break;
    }
}

- (void)stopLocation
{
    _status = SCLocationStatusFinish;
    
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
    }
    
    for (SCLocationBlock block in self.blockList) {
        block(self);
    }
    
    [self.blockList removeAllObjects];

    
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        //    定位精度（根据项目的要求来选择，精确越高，耗电量越大）
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //    距离过滤（触发定位代理的方法）
        _locationManager.distanceFilter = 50.0f;

        [_locationManager requestWhenInUseAuthorization];
//        [_locationManager requestAlwaysAuthorization];
        
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [CLGeocoder new];
    }
    return _geocoder;
}

#pragma mark -参数设置
- (void)setCity:(NSString *)city
{
    if (!VALID_STRING(city)) {
        _city = nil;
        return;
    }
    
    if ([city hasSuffix:@"市"]) { //把"市"移除
        city = [city substringToIndex:city.length -1];
    }
    
    //业务只涉及江苏省内城市
    city = [kCityCodeDict.allKeys containsObject:city] ? city : nil;
    
    _city = city;
}

- (NSString *)city
{
    if (!VALID_STRING(_city)) {
        _city = @"南京";
    }
    return _city;
}

- (NSString *)cityCode
{
    if (!_cityCode) {
        _cityCode = kCityCodeDict[self.city];
    }
    
    return _cityCode;
    

}

- (void)cleanData
{
    _status = SCLocationStatusNone;
    _longitude       = nil;
    _latitude        = nil;
    _cityCode        = nil;
    _city            = nil;
    _locationAddress = nil;
}

- (NSMutableArray<SCLocationBlock> *)blockList
{
    if (!_blockList) {
        _blockList = [NSMutableArray array];
    }
    return _blockList;
}

#pragma mark -坐标转换
+ (CLLocationCoordinate2D)gcj02Encrypt:(CLLocationCoordinate2D)wgsPt
{
    double ggLat = wgsPt.latitude;
    double ggLon = wgsPt.longitude;
    
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
