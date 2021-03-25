//
//  SCHomeViewModel.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeViewModel.h"
#import "SCShoppingManager.h"
#import "SCPopupManager.h"
#import "SCLocationService.h"

@interface SCHomeViewModel ()
@property (nonatomic, strong) SCUserInfo *lastUserInfo;

@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *topList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *bannerList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *gridList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *adList;                     //广告
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, SCHomeTouchModel *> *popupDict; //弹窗

@property (nonatomic, strong) SCHomeStoreModel *storeModel;               //推荐门店
@property (nonatomic, copy) NSMutableDictionary *serviceUrlCaches;

@property (nonatomic, strong) NSArray <SCGoodStoresModel *> *goodStoreList;              //发现好店

@property (nonatomic, strong) NSArray <SCCategoryModel *> *categoryList;                //分类

@property (nonatomic, strong) NSMutableArray<SCCommodityModel *> *commodityList;
@property (nonatomic, assign) BOOL hasNoData;


@end

@implementation SCHomeViewModel

#pragma mark -检测用户是否发生变化
- (BOOL)userHasChanged
{
    SCUserInfo *currentUser = [SCUserInfo currentUser];
    
    BOOL hasChanged = _lastUserInfo && (![currentUser.phoneNumber isEqualToString:_lastUserInfo.phoneNumber] || currentUser.isLogin != _lastUserInfo.isLogin);
    
    _lastUserInfo = currentUser;
    
    return hasChanged;
    
    
}

#pragma mark -触点相关
- (void)requestTouchData:(UIViewController *)viewController success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];

    if (![manager.delegate respondsToSelector:@selector(scADTouchDataFrom:backData:)]) {
        if (failure) {
            failure(@"delegate null");
        }
        return;
    }

    [manager.delegate scADTouchDataFrom:viewController backData:^(id  _Nonnull touchData) {
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
    //顶部按钮
    NSArray *topIds = @[@"DBBQLFL", @"DBBQLHD"];
    NSMutableArray *tempTops = [NSMutableArray arrayWithCapacity:topIds.count];
    
    for (NSString *topId in topIds) {
        NSMutableArray *models = [SCHomeTouchModel createModelsWithDict:result[topId]];
        if (models.count > 0) {
            [tempTops addObject:models.firstObject];
        }
    }
    self.topList = tempTops.copy;
    
    //宫格
    NSArray *gridIds = @[@"SCSYDYGG_I", @"SCSYDEGG_I", @"SCSYDSGG_I", @"SCSYDSGG1_I", @"SCSYDWGG_I", @"SCSYDLGG_I", @"SCSYDQGG_I", @"SCSYDBGG_I"];
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:gridIds.count];
    
    for (NSString *touchId in gridIds) {
        NSMutableArray *models = [SCHomeTouchModel createModelsWithDict:result[touchId]];
        if (models.count > 0) {
            [mulArr addObject:models.firstObject];
        }

    }
    
    self.gridList = mulArr.copy;
    
    //banner
    NSMutableArray *bannerModels = [SCHomeTouchModel createModelsWithDict:result[@"SCDBBANNER_I"]];
    //剔除空数据
    [bannerModels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SCHomeTouchModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!VALID_STRING(obj.picUrl)) {
            [bannerModels removeObject:obj];
        }
    }];
    self.bannerList = bannerModels.copy;
    
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
        
        for (SCHomeTouchModel *model in models) {
            NSNumber *popupNum = popupDict[popupId];
            BOOL show = [SCPopupManager validPopup:model type:popupNum.integerValue];
            if (show) {
                tempPopups[popupNum] = model;
                break;
            }
            
        }
        
    }
    
    self.popupDict = tempPopups.copy;
    
}


#pragma mark -推荐门店
- (void)requestRecommendStoreData:(SCHttpRequestCompletion)completion
{
    SCUserInfo *userInfo = [SCUserInfo currentUser];
    
    if (!VALID_STRING(userInfo.phoneNumber)) {
        self.storeModel = nil;
        
        if (completion) {
            completion(@"phone null");
        }
        
        return;
    }
    
    //有手机号，有定位才可以请求
    [[SCLocationService sharedInstance] startLocation:^(SCLocationService * _Nonnull ls) {
        [self requestRecommendStoreDataWithLongitude:ls.longitude latitude:ls.latitude userInfo:userInfo completion:completion];
    }];
}

- (void)requestRecommendStoreDataWithLongitude:(nullable NSString *)longitude latitude:(nullable NSString *)latitude userInfo:(SCUserInfo *)userInfo completion:(SCHttpRequestCompletion)completion
{
    NSDictionary *param = @{@"longitude": longitude?:@"",
                            @"latitude": latitude?:@"",
                            @"areaNum": userInfo.uan,
                            @"phoneNum": userInfo.phoneNumber};
    
    [SCRequestParams shareInstance].requestNum = @"apollo.queryFloorGoods";
    
    [SCNetworkManager POST:SC_STORE_FLOOR parameters:param success:^(id  _Nullable responseObject) {
        self.storeModel = nil;
        
        if (![SCNetworkTool checkResult:responseObject key:nil forClass:NSDictionary.class completion:completion]) {
            return;
        }
        
        NSDictionary *result = responseObject[B_RESULT];
        SCHomeStoreModel *storeModel = [SCHomeStoreModel yy_modelWithDictionary:result];
        
        if (!storeModel.storeId) {
            self.storeModel = storeModel;
            if (completion) {
                completion(nil);
            }
            return;
        }
        
        //请求完门店信息接口，还有三个接口需要请求
        //商品接口
        [self requestRecommendGoodsData:storeModel userInfo:userInfo completion:completion];
        
        //客服接口
        [self requestStoreService:storeModel userInfo:userInfo];
        
    } failure:^(NSString * _Nullable errorMsg) {
        self.storeModel = nil;
        if (completion) {
            completion(errorMsg);
        }
        
    }];
}

- (void)requestRecommendGoodsData:(SCHomeStoreModel *)storeModel userInfo:(SCUserInfo *)userInfo completion:(SCHttpRequestCompletion)completion
{
    [SCRequestParams shareInstance].requestNum = @"apollo.queryFloorGoods";
    
    dispatch_group_t group = dispatch_group_create();
    
    //接口1 ： 门店优惠
    dispatch_group_enter(group);
    NSDictionary *param1 = @{@"storeId": storeModel.storeId,
                            @"areaNum": userInfo.uan,
                            @"floorType": @"1"};
    
    
    
    [SCNetworkManager POST:SC_FLOOR_GOODS parameters:param1 success:^(id  _Nullable responseObject) {
        if ([SCNetworkTool checkResult:responseObject key:nil forClass:NSDictionary.class completion:nil]) {
            [storeModel parsingTopGoodsModelsFromData:responseObject[B_RESULT]];
        }
        
        dispatch_group_leave(group);
        
    } failure:^(NSString * _Nullable errorMsg) {
        dispatch_group_leave(group);
    }];
    
    
    //接口2 ： 活动
    dispatch_group_enter(group);
    NSDictionary *param2 = @{@"storeId": storeModel.storeId,
                            @"areaNum": userInfo.uan,
                            @"floorType": @"2"};
    
    
    
    [SCNetworkManager POST:SC_FLOOR_GOODS parameters:param2 success:^(id  _Nullable responseObject) {
        if ([SCNetworkTool checkResult:responseObject key:nil forClass:NSDictionary.class completion:nil]) {
            [storeModel parsingActivityModelsFromData:responseObject[B_RESULT]];
        }
        
        dispatch_group_leave(group);
        
    } failure:^(NSString * _Nullable errorMsg) {
        dispatch_group_leave(group);
    }];
    
    
    //请求完
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.storeModel = storeModel;
        if (completion) {
            completion(nil);
        }
        
    });
}

- (void)requestStoreService:(SCHomeStoreModel *)storeModel userInfo:(SCUserInfo *)userInfo
{
    if (!_serviceUrlCaches) {
        _serviceUrlCaches = [NSMutableDictionary dictionary];
    }
    
    //门店id和手机号相同，客服地址是一样的，不需要每次都请求
    NSString *cacheKey = [NSString stringWithFormat:@"%@+%@",storeModel.storeId,userInfo.phoneNumber];
    
    NSString *cacheUrl = _serviceUrlCaches[cacheKey];
    
    if (VALID_STRING(cacheUrl)) {
        storeModel.serviceUrl = cacheUrl;
        return;
    }
    
    
    NSDictionary *param = @{@"storeId": storeModel.storeId,
                            @"areaNum": userInfo.uan,
                            @"phoneNum": userInfo.phoneNumber};
    
    [SCRequestParams shareInstance].requestNum = @"apollo.customerService";
    
    [SCNetworkManager POST:SC_CUSTOMER_SERVICE parameters:param success:^(id  _Nullable responseObject) {
        if (![SCNetworkTool checkResult:responseObject key:nil forClass:NSString.class completion:nil]) {
            return;
        }
        
        NSString *url = responseObject[B_RESULT];
        
        storeModel.serviceUrl = url;
        
        self.serviceUrlCaches[cacheKey] = url; //缓存

    } failure:^(NSString * _Nullable errorMsg) {

    }];
}

#pragma mark -发现好店
- (void)requestGoodStoreList:(SCHttpRequestCompletion)completion
{
    [[SCLocationService sharedInstance] startLocation:^(SCLocationService * _Nonnull ls) {
        [self requestGoodStoreDataWithLongitude:ls.longitude latitude:ls.latitude completion:completion];
    }];
    
}

- (void)requestGoodStoreDataWithLongitude:(nullable NSString *)longitude latitude:(nullable NSString *)latitude completion:(SCHttpRequestCompletion)completion
{
    NSDictionary *param = @{@"longitude": longitude?:@"",
                            @"latitude": latitude?:@""};
    
    [SCRequestParams shareInstance].requestNum = @"shop.recommend";

    [SCNetworkManager POST:SC_SHOP_RECOMMEND parameters:param success:^(id  _Nullable responseObject) {
        NSString *key = @"shopList";
        if (![SCNetworkTool checkResult:responseObject key:key forClass:NSArray.class completion:completion]) {
            return;
        }
        
        NSArray *shopList = responseObject[B_RESULT][key];
        
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:shopList.count];
        
        for (NSDictionary *dict in shopList) {
            if (!VALID_DICTIONARY(dict)) {
                continue;
            }
            SCGoodStoresModel *model = [SCGoodStoresModel yy_modelWithDictionary:dict];

            if (model.shopInfo.isFindGood) {   //发现好店
                [mulArr addObject:model];
                
            }

        }
        
        self.goodStoreList = mulArr;
        
        if (completion) {
            completion(nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        self.goodStoreList = nil;
        if (completion) {
            completion(errorMsg);
        }
    }];
}

#pragma mark -分类
- (void)requestCategoryList:(SCHttpRequestCompletion)completion
{
    [SCRequest requestCategory:^(NSArray<SCCategoryModel *> * _Nonnull categoryList) {
        self.categoryList = categoryList;
        
        if (categoryList.count > 0) {
            self.categoryList.firstObject.selected = YES; //默认第一个选中
            
        }

        
        if (completion) {
            completion(nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        if (completion) {
            completion(errorMsg);
        }
    }];
    
}

#pragma mark -商品
- (void)requestCommodityListData:(NSString *)typeNum pageNum:(NSInteger)pageNum completion:(SCHttpRequestCompletion)completion
{
    [SCRequest requestCommoditiesWithTypeNum:(typeNum?:@"") brandNum:nil tenantNum:nil categoryName:nil cityNum:nil isPreSale:NO sort:SCCategorySortKeySale sortType:SCCategorySortTypeDesc pageNum:pageNum success:^(NSArray<SCCommodityModel *> * _Nonnull commodityList, NSArray * _Nonnull originDatas) {
        
        if (pageNum == 1) {
            [self.commodityList removeAllObjects];
        }
        
        [self.commodityList addObjectsFromArray:commodityList];
        self.hasNoData = commodityList.count < kCountCurPage;
        
        if (completion) {
            completion(nil);
        }
        
        
    } failure:^(NSString * _Nullable errorMsg) {
        
        if (completion) {
            completion(errorMsg);
        }
    }];
}

- (NSMutableArray<SCCommodityModel *> *)commodityList
{
    if (!_commodityList) {
        _commodityList = [NSMutableArray array];
    }
    return _commodityList;
}

@end
