//
//  SCShoppingManager.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

//备用定位，如果无法从代理获取定位，则自己定位一次
typedef void(^SCLocationBlock)(NSString * _Nullable longitude, NSString * _Nullable latitude);

@interface SCLocationService : NSObject

AS_SINGLETON(SCLocationService)

@property (nonatomic, copy, nullable) NSString *cityCode;
@property (nonatomic, copy, nullable) NSString *longitude;
@property (nonatomic, copy, nullable) NSString *latitude;
@property (nonatomic, copy, nullable) NSString *city;
@property (nonatomic, copy, nullable) NSString *locationAddress;

- (void)startLocation:(SCLocationBlock _Nullable )callBack;

- (void)cleanData;


@end
