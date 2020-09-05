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

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray <SCCategoryModel *> *categoryList;           //分类
@property (nonatomic, strong, readonly) NSMutableArray <SCCommodityModel *> *commodityList;  //商品
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *bannerList;            //banner
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *touchList;             //触点
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *adList;                //广告
@property (nonatomic, strong, readonly) SCHomeShopModel *nearShopModel;                      //附近门店
@property (nonatomic, strong, readonly) NSArray <SCHomeShopModel *> *goodShopList;           //发现好店


@property (nonatomic, assign, readonly) BOOL hasMoreData;            //是否请求完数据
@property (nonatomic, assign, readonly) BOOL commodityRequestFinish; //是否正在请求商品中

- (void)requestCommodityList:(NSInteger)pageNum completion:(SCHttpRequestCompletion)completion;

- (void)requestTouchData:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

- (void)requestStoreRecommend:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

@end

NS_ASSUME_NONNULL_END
