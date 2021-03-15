//
//  SCGoodStoreModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/19.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCGShopInfoModel;
@class SCGBannerModel;
@class SCGActModel;
@class SCGActImageModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCGoodStoreModel : NSObject
@property (nonatomic, strong) SCGShopInfoModel *shopInfo;
@property (nonatomic, strong) NSArray <SCGBannerModel *> *bannerList;
@property (nonatomic, strong) NSArray <SCGActModel *> *actList;
@property (nonatomic, strong) NSArray <NSString *> *couponList;

@end


@interface SCGShopInfoModel : NSObject
@property (nonatomic, copy) NSString *position;   //展示位置 (1-附近好店;2-发现好店)
@property (nonatomic, copy) NSString *storeCode;  //门店code
@property (nonatomic, copy) NSString *link;       //店铺链接地址
@property (nonatomic, copy) NSString *storeId;    //门店id
@property (nonatomic, copy) NSString *storeName;  //门店名称
@property (nonatomic, copy) NSString *label;      //旗舰/门店
@property (nonatomic, copy) NSString *defaultStr; //默认 逛智慧门店，立享会员服务

//自定义
@property (nonatomic, assign) BOOL isFindGood; //是否是发现好店
@end


@interface SCGBannerModel : NSObject
@property (nonatomic, copy) NSString *bannerImageLink; //
@property (nonatomic, copy) NSString *bannerImageUrl;

@end


@interface SCGActModel : NSObject
@property (nonatomic, copy) NSString *mainTitle; //发现好货
@property (nonatomic, copy) NSString *subTitle; //花花世界随心逛
@property (nonatomic, strong) NSArray <SCGActImageModel *> *actImageList;

@end

@interface SCGActImageModel : NSObject
@property (nonatomic, copy) NSString *sellingPoint; //价格 卖点
@property (nonatomic, copy) NSString *actImageUrl; //活动图片地址
@property (nonatomic, copy) NSString *actImageLink; //图片链接
@property (nonatomic, copy) NSString *title;  //标题

@end

NS_ASSUME_NONNULL_END
