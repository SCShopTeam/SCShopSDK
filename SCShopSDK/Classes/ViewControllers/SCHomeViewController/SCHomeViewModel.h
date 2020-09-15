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
#import "SCHomeStoreModel.h"
@class SCHomeCacheModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray <SCCategoryModel *> *categoryList;           //分类
@property (nonatomic, weak) SCHomeCacheModel *currentCacheModel;                   //商品列表缓存
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *bannerList;            //banner
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *touchList;             //触点
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *adList;                //广告
@property (nonatomic, strong, readonly) SCHomeStoreModel *recommendStoreModel;               //推荐门店
@property (nonatomic, strong, readonly) NSArray <SCHomeStoreModel *> *goodStoreList;         //发现好店

@property (nonatomic, assign, readonly) BOOL isCategoryRequesting; //是否正在请求分类信息和商品


- (void)requestCategoryList:(SCHttpRequestCompletion)completion;

- (void)getCommodityList:(NSInteger)pageNum showCache:(BOOL)showCache completion:(SCHttpRequestCompletion)completion;

- (void)requestTouchData:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

- (void)requestStoreList:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

- (SCHomeCacheModel *)getCacheModel:(NSInteger)index;

- (void)clear;

@end


@interface SCHomeCacheModel : NSObject
@property (nonatomic, strong) NSMutableArray <SCCommodityModel *> *commodityList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL hasMoreData;

@end

NS_ASSUME_NONNULL_END
