//
//  SCHomeViewModel.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCHomeTouchModel.h"
#import "SCHomeStoreModel.h"
#import "SCCategoryModel.h"
#import "SCCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *topList;
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *bannerList;
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *gridList;
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *adList;                     //广告
@property (nonatomic, strong, readonly) NSDictionary <NSNumber *, SCHomeTouchModel *> *popupDict; //弹窗

@property (nonatomic, strong, readonly) SCHomeStoreModel *recommendStoreModel;                    //推荐门店
@property (nonatomic, strong, readonly) NSArray <SCHomeStoreModel *> *goodStoreList;              //发现好店

@property (nonatomic, strong, readonly) NSArray <SCCategoryModel *> *categoryList;                //分类

@property (nonatomic, strong, readonly) NSMutableArray<SCCommodityModel *> *commodityList; //商品
@property (nonatomic, assign, readonly) BOOL hasNoData;

//触点
- (void)requestTouchData:(UIViewController *)viewController success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

//店铺
- (void)requestStoreList:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

//弹窗
//触点展示
- (void)touchShow:(SCHomeTouchModel *)model;
//触点点击
- (void)touchClick:(SCHomeTouchModel *)model;

//分类
- (void)requestCategoryList:(SCHttpRequestCompletion)completion;

//商品
- (void)requestCommodityListData:(NSString *)typeNum pageNum:(NSInteger)pageNum completion:(SCHttpRequestCompletion)completion;

@end

NS_ASSUME_NONNULL_END
