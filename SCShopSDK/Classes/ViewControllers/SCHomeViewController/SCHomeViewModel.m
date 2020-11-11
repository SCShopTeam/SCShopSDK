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
#import "SCPopupManager.h"

@interface SCHomeViewModel ()
@property (nonatomic, strong) NSArray <SCCategoryModel *> *categoryList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *bannerList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *touchList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *adList;                     //广告
@property (nonatomic, strong) SCHomeStoreModel *recommendStoreModel;                    //推荐门店
@property (nonatomic, strong) NSArray <SCHomeStoreModel *> *goodStoreList;              //发现好店
@property (nonatomic, strong) NSDictionary <NSNumber *, SCHomeTouchModel *> *popupDict; //弹窗

@property (nonatomic, assign) BOOL isStoreRequesting;
//@property (nonatomic, weak) SCHomeCacheModel *currentCacheModel;                      //商品列表缓存
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, SCHomeCacheModel *> *commodityDict;

@property (nonatomic, assign) BOOL isCategoryRequesting; //是否正在请求商品

@property (nonatomic, assign) BOOL hasShowedTouch; //是否已经成功展示过触点

@end

@implementation SCHomeViewModel

- (void)clear
{
    self.recommendStoreModel = nil;
    self.goodStoreList = nil;
    [self.commodityDict removeAllObjects];
}

- (void)requestCategoryList:(SCHttpRequestCompletion)completion
{
    self.isCategoryRequesting = YES;
    [SCCategoryViewModel requestCategory:^(NSArray<SCCategoryModel *> * _Nonnull categoryList) {
        categoryList.firstObject.selected = YES;  //默认第一个选中
        self.categoryList = categoryList;
        [self.commodityDict removeAllObjects];
        
        if (completion) {
            completion(nil);
        }
  
    } failure:^(NSString * _Nullable errorMsg) {
        self.isCategoryRequesting = NO;
        if (completion) {
            completion(errorMsg);
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
        self.isCategoryRequesting = NO;
        
    }else {
        [self requestCommodityListData:pageNum index:index completion:completion];
    }
    
    //同时提前请求并缓存下一个和前一个index的数据
    [self cacheDataLast:index-1 next:index+1 completion:nil];

}

- (void)cacheDataLast:(NSInteger)lastIndex next:(NSInteger)nextIndex completion:(SCHttpRequestCompletion)completion
{
    if (lastIndex >= 0) {
        SCHomeCacheModel *lastModel = self.commodityDict[@(lastIndex)];
        if (!lastModel) {
            [self requestCommodityListData:1 index:lastIndex completion:completion];
        }
    }
    
    if (nextIndex < self.categoryList.count) {
        SCHomeCacheModel *nextModel = self.commodityDict[@(nextIndex)];
        if (!nextModel) {
            [self requestCommodityListData:1 index:nextIndex completion:completion];
        }
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
        self.isCategoryRequesting = NO;

    } failure:^(NSString * _Nullable errorMsg) {
        if (categoryModel.selected) {
            self.currentCacheModel = nil;
        }
        
        if (completion) {
            completion(errorMsg);
        }
        self.isCategoryRequesting = NO;
    }];
    
}

- (SCHomeCacheModel *)getCacheModel:(NSInteger)index
{
    SCHomeCacheModel *model = self.commodityDict[@(index)];
    return model;
}

- (void)requestTouchData:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    if (self.hasShowedTouch) { //本次启动商城展示过触点后，不再请求触点数据
        return;
    }
    
        //>>>>删
    if ([SCUtilities isInShoppingDebug]) {
        NSDictionary *dict = @{@"SCDBBANNER_I":@{@"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/30725ab5dee54dc291439844f2e03641.png"},@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/77a9a0373014428e85bf6d30accabcf5.png"},@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/ca31256176734973b5915db2ce2bdd9a.jpg"}]
                                                 
        },
                               @"SCSYCBLFC_I" : @{@"contactName" : @"商城首页侧边栏浮层",
                                                  @"periodCount": @99,
                                                  @"periodType":@"MONTH",
                                                  @"cpmMax": @3,
                                                  @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/9504e3e32a6d404495de95e9307662a1.png",@"linkUrl": @"http://wap.js.10086.cn/nact/2204", @"contentNum": @"nlasretyrefds,d"}]},
                               @"SCSYZXDC_I" : @{@"contactName" : @"商城首页中心弹窗",@"periodCount": @99,@"periodType":@"MONTH",@"cpmMax": @5,
                               @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/9504e3e32a6d404495de95e9307662a1.png",@"linkUrl": @"http://wap.js.10086.cn/nact/2204", @"contentNum": @"sddskghjdddddmghj31"}]},
                               @"SCSYDBYXDC_I" : @{@"contactName" : @"商城首页底部异形弹窗",@"periodCount": @99,@"periodType":@"MONTH",@"cpmMax": @5,
                               @"content":@[@{@"picUrl":@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/rec_resource/9504e3e32a6d404495de95e9307662a1.png",@"linkUrl": @"http://wap.js.10086.cn/nact/2204", @"contentNum": @"sdfsdyjuserfgfdgfasaa12131"}]},
        };
        
        [self parsingTouchData:dict];
        self.hasShowedTouch = YES;
        success(nil);
        
        return;
    }

    
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
            self.hasShowedTouch = YES;
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
        NSMutableArray *models = [SCHomeTouchModel createModelsWithDict:result[touchId]];
        if (models.count > 0) {
            [mulArr addObject:models.firstObject];
        }

    }
    
    self.touchList = mulArr.copy;
    
    //banner
    NSMutableArray *bannerModels = [SCHomeTouchModel createModelsWithDict:result[@"SCDBBANNER_I"]];
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
        NSMutableArray *models = [SCHomeTouchModel createModelsWithDict:result[adId]];
        if (models.count > 0) {
            [tempAds addObject:models.firstObject];
        }
    }
    self.adList = tempAds.copy;
    
    
    //弹窗
    NSDictionary *popupDict = @{@"SCSYCBLFC_I": @(SCPopupTypeSide),
                                @"SCSYZXDC_I": @(SCPopupTypeCenter),
                                @"SCSYDBYXDC_I": @(SCPopupTypeBottom)};
    
    NSMutableDictionary *tempPopups = [NSMutableDictionary dictionary];
    for (NSString *popupId in popupDict.allKeys) {
        NSMutableArray *models = [SCHomeTouchModel createModelsWithDict:result[popupId]];
        if (models.count > 0) {
            SCHomeTouchModel *model = models.firstObject;
            
            NSNumber *popupNum = popupDict[popupId];
            BOOL show = [SCPopupManager validPopup:model type:popupNum.integerValue];
            
            if (show) {
                tempPopups[popupNum] = model;
            }
            
        }
    }
    
    self.popupDict = tempPopups.copy;
    
}


- (void)requestStoreList:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    if (self.isStoreRequesting) {
        return;
    }

    [[SCLocationService sharedInstance] startLocation:^(NSString * _Nullable longitude, NSString * _Nullable latitude) {
        [self requestStoreDataWithLongitude:longitude latitude:latitude success:success failure:failure];
    }];
    

    
}

- (void)requestStoreDataWithLongitude:(nullable NSString *)longitude latitude:(nullable NSString *)latitude success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    self.isStoreRequesting = YES;
    
    NSDictionary *param = @{@"longitude": longitude?:@"",
                            @"latitude": latitude?:@""};
    
    [SCRequestParams shareInstance].requestNum = @"shop.recommend";

    [SCNetworkManager POST:SC_SHOP_RECOMMEND parameters:param success:^(id  _Nullable responseObject) {
        self.isStoreRequesting = NO;
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
            SCHomeStoreModel *model = [SCHomeStoreModel yy_modelWithDictionary:dict];

            if (model.shopInfo.isFindGood) {   //发现好店
                [mulArr addObject:model];
                
            }else {   //附近门店
                self.recommendStoreModel = model;
            }
        }
        
        self.goodStoreList = mulArr;
        
        
        if (success) {
            success(nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        self.isStoreRequesting = NO;
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
