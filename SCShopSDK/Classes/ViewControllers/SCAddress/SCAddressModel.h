//
//  SCAddressModel.h
//  shopping
//
//  Created by gejunyu on 2020/7/31.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCAdminListModel;

NS_ASSUME_NONNULL_BEGIN

//收货地址

@interface SCAddressModel : NSObject
@property (nonatomic, copy) NSString *addressNum;      //地址编码
@property (nonatomic, copy) NSString *realName;        //收货人姓名
@property (nonatomic, copy) NSString *mobile;          //手机号码
@property (nonatomic, copy) NSString *provinceNum;     //省份编码
@property (nonatomic, copy) NSString *provinceName;    //省份名称
@property (nonatomic, copy) NSString *cityNum;         //城市编码
@property (nonatomic, copy) NSString *cityName;        //城市名称
@property (nonatomic, copy) NSString *regionNum;       //区县编码
@property (nonatomic, copy) NSString *regionName;      //区县名称
@property (nonatomic, copy) NSString *detail;          //详细地址
@property (nonatomic, assign) BOOL isDefault;          //是否默认地址

- (void)copyData:(SCAddressModel *)otherModel;

@end

NS_ASSUME_NONNULL_END
