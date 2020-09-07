//
//  SCHomeViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCategoryModel.h"
#import "SCCommodityModel.h"
#import "SCHomeTouchModel.h"
#import "SCHomeShopModel.h"
@class SCHomeCacheModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray <SCCategoryModel *> *categoryList;           //分类
@property (nonatomic, weak, readonly) SCHomeCacheModel *currentCacheModel;                   //商品列表缓存
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *bannerList;            //banner
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *touchList;             //触点
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *adList;                //广告
@property (nonatomic, strong, readonly) SCHomeShopModel *nearShopModel;                      //附近门店
@property (nonatomic, strong, readonly) NSArray <SCHomeShopModel *> *goodShopList;           //发现好店


- (void)requestCategoryList:(SCHttpRequestCompletion)completion;

- (void)getCommodityList:(NSInteger)pageNum showCache:(BOOL)showCache completion:(SCHttpRequestCompletion)completion;

- (void)requestTouchData:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

- (void)requestStoreRecommend:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

@end


@interface SCHomeCacheModel : NSObject
@property (nonatomic, strong) NSMutableArray <SCCommodityModel *> *commodityList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, assign) CGFloat contentOffsetY;

@end

NS_ASSUME_NONNULL_END
