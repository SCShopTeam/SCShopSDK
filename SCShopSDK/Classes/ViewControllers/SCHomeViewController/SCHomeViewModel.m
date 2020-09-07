//
//  SCHomeViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomeViewModel.h"
#import "SCCategoryViewModel.h"
#import "SCShoppingManager.h"
#import "SCCacheManager.h"
#import "SCLocationService.h"

@interface SCHomeViewModel ()
@property (nonatomic, strong) NSArray <SCCategoryModel *> *categoryList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *bannerList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *touchList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *adList;                //广告
@property (nonatomic, strong) SCHomeShopModel *nearShopModel;                      //附近门店
@property (nonatomic, strong) NSArray <SCHomeShopModel *> *goodShopList;           //发现好店

@property (nonatomic, assign) BOOL isShopRequesting;
@property (nonatomic, weak) SCHomeCacheModel *currentCacheModel;                   //商品列表缓存
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, SCHomeCacheModel *> *commodityDict;

@end

@implementation SCHomeViewModel

- (void)requestCategoryList:(SCHttpRequestCompletion)completion
{
    [SCCategoryViewModel requestCategory:^(NSArray<SCCategoryModel *> * _Nonnull categoryList) {
        if (categoryList.count == 0) {
            self.categoryList = nil;
            if (completion) {
                completion(@"获取分类信息失败");
            }
            return;
        }
        
        categoryList.firstObject.selected = YES;  //默认第一个选中
        self.categoryList = categoryList;
        [self.commodityDict removeAllObjects];
        
        //分类信息请求完，提前请求所有商品列表(除了第一个选中的,外部会请求)
        [self.categoryList enumerateObjectsUsingBlock:^(SCCategoryModel * _Nonnull cModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                [self requestCommodityListData:1 index:idx completion:nil];
            }
            
        }];
        
        if (completion) {
            completion(nil);
        }
        

        
        
    } failure:^(NSString * _Nullable errorMsg) {
        if (completion) {
            completion(@"获取分类信息失败");
        }
    }];
}


- (void)getCommodityList:(NSInteger)pageNum showCache:(BOOL)showCache completion:(SCHttpRequestCompletion)completion
{
    __block NSInteger index = 0;
    [self.categoryList enumerateObjectsUsingBlock:^(SCCategoryModel * _Nonnull cModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (cModel.selected) {
            index = idx;
            *stop = YES;
        }
    }];
    
    SCHomeCacheModel *cacheModel = self.commodityDict[@(index)];
    
    if (showCache && cacheModel) {
        self.currentCacheModel = cacheModel;
        if (completion) {
            completion(nil);
        }
        
    }else {
        [self requestCommodityListData:pageNum index:index completion:completion];
    }

}

- (void)requestCommodityListData:(NSInteger)pageNum index:(NSInteger)index completion:(SCHttpRequestCompletion)completion
{

    SCCategoryModel *categoryModel = self.categoryList[index];
    NSString *typeNum = categoryModel.typeNum ?: @"";
    
    [SCCategoryViewModel requestCommoditiesWithTypeNum:typeNum brandNum:nil tenantNum:nil categoryName:nil cityNum:nil isPreSale:NO sort:SCCategorySortKeySale sortType:SCCategorySortTypeDesc pageNum:pageNum success:^(NSMutableArray<SCCommodityModel *> * _Nonnull commodityList) {
        SCHomeCacheModel *cacheModel = self.commodityDict[@(index)];
        if (!cacheModel) {
            cacheModel = [SCHomeCacheModel new];
            self.commodityDict[@(index)] = cacheModel;
        }
        
        if (pageNum == 1) {
            cacheModel.page = 1;
            [cacheModel.commodityList removeAllObjects];
        }
        
        [cacheModel.commodityList addObjectsFromArray:commodityList];
        cacheModel.hasMoreData = commodityList.count >= kCountCurPage;
        cacheModel.page = pageNum;
        
        if (categoryModel.selected) {
            self.currentCacheModel = cacheModel;
            if (completion) {
                completion(nil);
            }
        }


    } failure:^(NSString * _Nullable errorMsg) {
        
        if (completion) {
            completion(errorMsg);
        }
    }];
    
    //    if (pageNum == 1) {
    //        if (!_commodityList) {
    //            _commodityList = [NSMutableArray arrayWithCapacity:kCountCurPage];
    //        }else {
    //            [_commodityList removeAllObjects];
    //        }
    //    }
    //
    //
    //
    //    NSString *typeNum = @"";
    //
    //    for (SCCategoryModel *cModel in self.categoryList) {
    //        if (cModel.selected) {
    //            typeNum = cModel.typeNum;
    //            break;
    //        }
    //    }
    //
    //    [SCCategoryViewModel requestCommoditiesWithTypeNum:typeNum brandNum:nil tenantNum:nil categoryName:nil cityNum:nil isPreSale:NO sort:SCCategorySortKeySale sortType:SCCategorySortTypeDesc pageNum:pageNum success:^(NSMutableArray<SCCommodityModel *> * _Nonnull commodityList) {
    //        self.commodityRequestFinish = YES;
    //
    //        [self.commodityList addObjectsFromArray:commodityList];
    //        self.hasMoreData = commodityList.count >= kCountCurPage;
    //
    //        if (completion) {
    //            completion(nil);
    //        }
    //
    //    } failure:^(NSString * _Nullable errorMsg) {
    //        self.commodityRequestFinish = YES;
    //
    //        if (completion) {
    //            completion(errorMsg);
    //        }
    //    }];
}

- (void)requestTouchData:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];

    if (![manager.delegate respondsToSelector:@selector(scADTouchDataWithTouchPageNum:backData:)]) {
        if (failure) {
            failure(@"delegate null");
        }
        return;
    }

    [manager.delegate scADTouchDataWithTouchPageNum:@"B2CSCSY" backData:^(id  _Nonnull touchData) {
        if (!VALID_DICTIONARY(touchData)) {
            if (failure) {
                failure(@"get touch failure");
            }

        }else {
            [self parsingTouchData:touchData];
            if (success) {
                success(nil);
            }

        }

    }];
}

- (void)parsingTouchData:(NSDictionary *)result
{
    //触点  排序
    NSArray *touchIds = @[@"SCSYDYGG_I", @"SCSYDEGG_I", @"SCSYDSGG_I", @"SCSYDSGG1_I", @"SCSYDWGG_I", @"SCSYDLGG_I", @"SCSYDQGG_I", @"SCSYDBGG_I"];
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:touchIds.count];
    
    for (NSString *touchId in touchIds) {
        NSArray *contentArray = [self getContent:touchId fromResult:result];
        if (!contentArray) {
            continue;
        }
        SCHomeTouchModel *model = contentArray.firstObject;
        [mulArr addObject:model];
    }
    
    self.touchList = mulArr.copy;
    
    //banner
    NSMutableArray *bannerModels = [self getContent:@"SCDBBANNER_I" fromResult:result];
    //剔除空数据
    [bannerModels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SCHomeTouchModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!VALID_STRING(obj.picUrl)) {
            [bannerModels removeObject:obj];
        }
    }];
    self.bannerList = bannerModels;
    
    //广告
    NSArray *adIds = @[@"SCSYHDWY_I", @"SCSYHDWE_I"];
    NSMutableArray *tempAds = [NSMutableArray arrayWithCapacity:adIds.count];
    for (NSString *adId in adIds) {
        NSArray *contentArray = [self getContent:adId fromResult:result];
        if (!contentArray) {
            continue;
        }
        SCHomeTouchModel *model = contentArray.firstObject;
        [tempAds addObject:model];
    }
    self.adList = tempAds.copy;

}

- (nullable NSMutableArray <SCHomeTouchModel *>*)getContent:(NSString *)touchId fromResult:(NSDictionary *)result
{
    if (![result.allKeys containsObject:touchId]) {
        return nil;
    }
    NSDictionary *touchDict = result[touchId];
    if (!VALID_DICTIONARY(touchDict)) {
        return nil;
    }
    
    if (![touchDict.allKeys containsObject:@"content"]) {
        return nil;
    }
    
    NSArray *content = touchDict[@"content"];
    if (!VALID_ARRAY(content)) {
        return nil;
    }
    
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:content.count];
    for (NSDictionary *dict in content) {
        if (VALID_DICTIONARY(dict)) {
            SCHomeTouchModel *model = [SCHomeTouchModel yy_modelWithDictionary:dict];
            [mulArr addObject:model];
        }
    }

    return mulArr;
}


- (void)requestStoreRecommend:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    if (self.isShopRequesting) {
        return;
    }

    [[SCLocationService sharedInstance] startLocation:^(NSString * _Nullable longitude, NSString * _Nullable latitude) {
        if (!VALID_STRING(longitude) || !VALID_STRING(latitude)) {
            if (failure) {
                failure(@"获取定位失败");
            }
            
        }else {
            [self requestStoreRecommendWithLongitude:longitude latitude:latitude success:success failure:failure];
            
        }
    }];
    

    
}

- (void)requestStoreRecommendWithLongitude:(NSString *)longitude latitude:(NSString *)latitude success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    self.isShopRequesting = YES;
    
    NSDictionary *param = @{@"longitude": longitude,
                            @"latitude": latitude};
    
    [SCRequestParams shareInstance].requestNum = @"shop.recommend";

    [SCNetworkManager POST:SC_SHOP_RECOMMEND parameters:param success:^(id  _Nullable responseObject) {
        self.isShopRequesting = NO;
        NSString *key = @"shopList";
        if (![SCNetworkTool checkResult:responseObject key:key forClass:NSArray.class failure:failure]) {
            return;
        }
        
        NSArray *shopList = responseObject[B_RESULT][key];
        
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:shopList.count];
        
        for (NSDictionary *dict in shopList) {
            if (!VALID_DICTIONARY(dict)) {
                continue;
            }
            SCHomeShopModel *model = [SCHomeShopModel yy_modelWithDictionary:dict];

            if (model.shopInfo.isFindGood) {   //发现好店
                [mulArr addObject:model];
                
            }else {   //附近门店
                self.nearShopModel = model;
            }
        }
        
        self.goodShopList = mulArr;
        
        
        if (success) {
            success(nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        self.isShopRequesting = NO;
        if (failure) {
            failure(errorMsg);
        }
    }];
}

- (NSMutableDictionary<NSNumber *,SCHomeCacheModel *> *)commodityDict
{
    if (!_commodityDict) {
        _commodityDict = [NSMutableDictionary dictionary];
    }
    return _commodityDict;
}

@end



@implementation SCHomeCacheModel

- (NSMutableArray<SCCommodityModel *> *)commodityList
{
    if (!_commodityList) {
        _commodityList = [NSMutableArray array];
    }
    return _commodityList;
}

@end
