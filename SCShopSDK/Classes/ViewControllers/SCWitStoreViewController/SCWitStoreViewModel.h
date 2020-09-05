//
//  SCWitStoreViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/28.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCWitStoreModel.h"
#import "SCAreaModel.h"
#import "SCWitStoreGoodModel.h"
#import "SCWitStoreHeader.h"
@class SCWitRequestModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCWitStoreViewModel : NSObject

@property (nonatomic, strong, readonly) SCWitStoreModel *nearStoreModel;                //距离最近
@property (nonatomic, strong, readonly) NSMutableArray <SCWitStoreModel *> *storeList;  //查询列表
@property (nonatomic, strong, readonly) NSArray <SCWitStoreModel *> *professionalList;  //猜你喜欢
@property (nonatomic, strong, readonly) NSArray <SCAreaModel *> *areaList;              //地市列表
@property (nonatomic, strong, readonly) NSArray <SCWitStoreGoodModel *> *goodsList;     //推荐商品
@property (nonatomic, assign, readonly) BOOL hasMoreData;

@property (nonatomic, assign, readonly) BOOL showProfessionalList;


//请求模型
@property (nonatomic, strong, readonly) SCWitRequestModel *requestModel;


//地市列表
- (void)requestAreaList:(void (^)(NSString *areaName))areaBlock;

//门店
- (void)requestAggregateStoreWithPage:(NSInteger)page completion:(SCHttpRequestCompletion)completion;

//推荐商品
- (void)requestRecommendGoods:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

//推荐门店
//- (void)requestProfessionalStore:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

//立即取号
- (void)requestVouchNumber:(SCWitStoreModel *)model success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;


@end


@interface SCWitRequestModel : NSObject
@property (nonatomic, copy) NSString *busiRegCityCode;
@property (nonatomic, assign) SCWitQueryType queryType;
@property (nonatomic, assign) SCWitSortType sortType;
@property (nonatomic, copy, nullable) NSString *queryStr;
@property (nonatomic, assign) NSInteger page;

@end

NS_ASSUME_NONNULL_END
