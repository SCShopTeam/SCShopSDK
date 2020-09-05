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
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, strong) NSArray <SCCategoryModel *> *categoryList;
@property (nonatomic, strong) NSMutableArray <SCCommodityModel *> *commodityList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *bannerList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *touchList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *adList;                //广告
@property (nonatomic, strong) SCHomeShopModel *nearShopModel;                      //附近门店
@property (nonatomic, strong) NSArray <SCHomeShopModel *> *goodShopList;           //发现好店

@property (nonatomic, assign) BOOL isCategoryRequesting;
@property (nonatomic, assign) BOOL isShopRequesting;
@property (nonatomic, assign) BOOL commodityRequestFinish;
@end

@implementation SCHomeViewModel

- (void)requestCommodityList:(NSInteger)pageNum completion:(SCHttpRequestCompletion)completion
{
    self.commodityRequestFinish = NO;
    
    //先看列表标签是否已经请求好
    if (VALID_ARRAY(self.categoryList)) {
        [self requestCommodityDatas:pageNum completion:completion];
        
        return;
    }
    
    //看看是否在请求
    if (_isCategoryRequesting) {
        return;
    }
    
    _isCategoryRequesting = YES;
    //没有标签先请求
    [SCCategoryViewModel requestCategory:^(NSArray<SCCategoryModel *> * _Nonnull categoryList) {
        self.isCategoryRequesting = NO;
        
        if (categoryList.count > 0) {
            categoryList.firstObject.selected = YES;  //默认第一个选中
        }
        
        self.categoryList = categoryList;
        
        [self requestCommodityDatas:pageNum completion:completion];
        
    } failure:^(NSString * _Nullable errorMsg) {
        self.isCategoryRequesting = NO;
        if (completion) {
            completion(errorMsg);
        }
    }];


}

- (void)requestCommodityDatas:(NSInteger)pageNum completion:(SCHttpRequestCompletion)completion
{
    if (self.categoryList.count == 0) {
        if (completion) {
            completion(@"param null");
        }
        return;
    }
    
    self.commodityRequestFinish = NO;
    
    if (pageNum == 1) {
        if (!_commodityList) {
            _commodityList = [NSMutableArray arrayWithCapacity:kCountCurPage];
        }else {
            [_commodityList removeAllObjects];
        }
    }
    
    

    NSString *typeNum = @"";
    
    for (SCCategoryModel *cModel in self.categoryList) {
        if (cModel.selected) {
            typeNum = cModel.typeNum;
            break;
        }
    }
    
    [SCCategoryViewModel requestCommoditiesWithTypeNum:typeNum brandNum:nil tenantNum:nil categoryName:nil cityNum:nil isPreSale:NO sort:SCCategorySortKeySale sortType:SCCategorySortTypeDesc pageNum:pageNum success:^(NSMutableArray<SCCommodityModel *> * _Nonnull commodityList) {
        self.commodityRequestFinish = YES;
        
        [self.commodityList addObjectsFromArray:commodityList];
        self.hasMoreData = commodityList.count >= kCountCurPage;
        
        if (completion) {
            completion(nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        self.commodityRequestFinish = YES;
        
        if (completion) {
            completion(errorMsg);
        }
    }];
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


@end
