//
//  SCShoppingManager.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCLocationService;

typedef void(^SCLocationBlock)(SCLocationService * _Nonnull ls);

@interface SCLocationService : NSObject

+ (instancetype _Nonnull)sharedInstance;

@property (nonatomic, copy, nonnull)  NSString *cityCode;
@property (nonatomic, copy, nullable) NSString *longitude;
@property (nonatomic, copy, nullable) NSString *latitude;
@property (nonatomic, copy, nonnull)  NSString *city;
@property (nonatomic, copy, nullable) NSString *locationAddress;

- (void)startLocation:(SCLocationBlock _Nullable )callBack useCache:(BOOL)useCache;
- (void)startLocation:(SCLocationBlock _Nullable )callBack;

- (void)cleanData;


@end
