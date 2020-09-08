//
//  SCStoreHomeViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCStoreHomeViewModel.h"

@interface SCStoreHomeViewModel ()
@property (nonatomic, strong) SCTenantInfoModel *tenantInfo;
@property (nonatomic, strong) NSMutableDictionary <NSString *, SCStoreHomeCacheModel *> *commodityDict;
@property (nonatomic, weak) SCStoreHomeCacheModel *currentCacheModel;
@property (nonatomic, copy) NSString *currentKey;

@property (nonatomic, assign) BOOL hasCached;

@end

@implementation SCStoreHomeViewModel


- (void)requestTenantInfo:(NSString *)tenantNum completion:(nonnull SCHttpRequestCompletion)completion
{
    [SCRequestParams shareInstance].requestNum = @"tenant.info";
    NSDictionary *param = @{@"tenantNum": tenantNum};
    
    [SCNetworkManager GET:SC_GOODTENANT_INFO parameters:param success:^(id  _Nullable responseObject) {
        if (![SCNetworkTool checkResult:responseObject key:nil forClass:NSDictionary.class completion:completion]) {
            return;
        }
        
        NSDictionary *result = responseObject[B_RESULT];
        
        SCTenantInfoModel *model = [SCTenantInfoModel yy_modelWithDictionary:result];
        
        self.tenantInfo = model;
        
        if (completion) {
            completion(nil);
        }
        
        
    } failure:^(NSString * _Nullable errorMsg) {
        if (completion) {
            completion(errorMsg);
        }
    }];
}

- (NSString *)getCacheKeyFromSort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType
{
    NSString *key = [NSString stringWithFormat:@"%li-%li",sort, sortType];
    return key;
}

- (void)getCommodityList:(NSString *)tenantNum sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum showCache:(BOOL)showCache completion:(SCHttpRequestCompletion)completion
{
    NSString *key = [self getCacheKeyFromSort:sort sortType:sortType];
    self.currentKey = key;
    
    SCStoreHomeCacheModel *cacheModel = self.commodityDict[key];
    
    if (showCache && cacheModel) {
        self.currentCacheModel = cacheModel;
        if (completion) {
            completion(nil);
        }
    }else {
        [self requestCommodityListData:tenantNum sort:sort sortType:sortType pageNum:pageNum  completion:completion];
    }
    
    if (!_hasCached) { //未做过缓存，先做一次缓存
        _hasCached = YES;
        for (int i = SCCategorySortKeyRecommand; i<SCCategorySortKeySale+1; i++) {
            for (int y = SCCategorySortTypeAsc; y < SCCategorySortTypeDesc+1; y++) {
                NSString *k = [self getCacheKeyFromSort:i sortType:y];
                if (![k isEqualToString:key]) {
                    [self requestCommodityListData:tenantNum sort:i sortType:y pageNum:1 completion:completion];
                }
            }
        }
    }
}

- (void)requestCommodityListData:(NSString *)tenantNum sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum completion:(nonnull SCHttpRequestCompletion)completion
{
    self.currentCacheModel = nil;
    
    [SCCategoryViewModel requestCommoditiesWithTypeNum:nil brandNum:nil tenantNum:tenantNum categoryName:nil cityNum:nil isPreSale:NO sort:sort sortType:sortType pageNum:pageNum success:^(NSMutableArray<SCCommodityModel *> * _Nonnull commodityList) {
        NSString *key = [self getCacheKeyFromSort:sort sortType:sortType];
        
        SCStoreHomeCacheModel *cacheModel = self.commodityDict[key];
        
        if (!cacheModel) {
            cacheModel = [SCStoreHomeCacheModel new];
            self.commodityDict[key] = cacheModel;
        }
        
        
        if (pageNum == 1) {
            [cacheModel.commodityList removeAllObjects];
        }
        
        [cacheModel.commodityList addObjectsFromArray:commodityList];
        cacheModel.hasMoreData = commodityList.count >= kCountCurPage;
        cacheModel.page = pageNum;
        
        if ([self.currentKey isEqualToString:key]) {
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
}

- (NSMutableDictionary<NSString *,SCStoreHomeCacheModel *> *)commodityDict
{
    if (!_commodityDict) {
        _commodityDict = [NSMutableDictionary dictionary];
    }
    return _commodityDict;
}

@end


@implementation SCStoreHomeCacheModel

- (NSMutableArray<SCCommodityModel *> *)commodityList
{
    if (!_commodityList) {
        _commodityList = [NSMutableArray array];
    }
    return _commodityList;
}

@end
