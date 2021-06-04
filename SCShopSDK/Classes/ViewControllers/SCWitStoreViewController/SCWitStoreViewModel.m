//
//  SCWitStoreViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/28.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCWitStoreViewModel.h"
#import "SCLocationService.h"
#import "SCWitStoreCell.h"
#import "SCWitStoreHeaderView.h"

@interface SCWitRequestModel ()
- (NSDictionary *)getParams;
@end

@interface SCWitStoreViewModel ()
@property (nonatomic, assign) BOOL isCommited; //是否上传过时长统计

@property (nonatomic, strong) SCWitStoreModel *nearStoreModel;                //距离最近
//@property (nonatomic, strong) NSMutableArray <SCWitStoreModel *> *storeList;  //查询列表
@property (nonatomic, strong) NSArray <SCWitStoreModel *> *professionalList;  //猜你喜欢
@property (nonatomic, strong) NSArray <SCAreaModel *> *areaList;              //地市列表
@property (nonatomic, strong) NSArray <SCWitStoreGoodModel *> *goodsList;     //推荐商品
//@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, weak) SCWitStoreCacheModel *currentCacheModel;

@property (nonatomic, strong) SCWitRequestModel *requestModel;
@property (nonatomic, copy) NSString *currentKey;
@property (nonatomic, strong) NSMutableDictionary <NSString *, SCWitStoreCacheModel *> *storeDict;
@property (nonatomic, strong) SCWitStoreCacheModel *searchResultModel;

@end

@implementation SCWitStoreViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self requestProfessionalStore];
    }
    return self;
}

- (void)cleanCacheData
{
    [self.storeDict removeAllObjects];
}

//地市列表
- (void)requestAreaList:(UIViewController *)viewController areaBlock:(void (^)(NSString * _Nonnull))areaBlock
{
    __block NSString *cityName = [SCLocationService sharedInstance].city;
    self.requestModel.busiRegCityCode = [SCLocationService sharedInstance].cityCode;
    
    //时长统计
    if (!_isCommited) {
        [SCUtilities pageStart:viewController loadPageName:@"官方好店"];
    }
    
    [SCRequestParams shareInstance].requestNum = @"apollo.queryAreaListAppTerminal";
    [SCNetworkManager POST:SC_AREA_LIST_AT parameters:nil success:^(id  _Nullable responseObject) {
        if ([SCNetworkTool checkResult:responseObject key:nil forClass:NSArray.class failure:nil]) {
            SCUserInfo *user = [SCUserInfo currentUser];
            
            NSArray *areaList = responseObject[A_RESULT];
            
            NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:areaList.count];
            for (NSDictionary *dict in areaList) {
                if (!VALID_DICTIONARY(dict)) {
                    continue;
                }
                SCAreaModel *model = [SCAreaModel yy_modelWithDictionary:dict];
                
                if (user.isLogin && [model.code isEqualToString:user.uan]) {
                    model.selected = YES;
                    self.requestModel.busiRegCityCode = model.code;
                    cityName = model.name;
                }
                
                [mulArr addObject:model];
            }

            self.areaList = mulArr.copy;
              
        }
        
        if (!self.isCommited) {
            self.isCommited = YES;
            [SCUtilities pageEnd:viewController errorMessage:nil];
        }

        if (areaBlock) {
            areaBlock(cityName);
        }
        

    } failure:^(NSString * _Nullable errorMsg) {
        if (!self.isCommited) {
            self.isCommited = YES;
            [SCUtilities pageEnd:viewController errorMessage:errorMsg];
        }
        
        if (areaBlock) {
            areaBlock(cityName);
        }
    }];
}

- (NSString *)getCacheKey
{
    NSMutableString *key = [NSMutableString stringWithFormat:@"%li_%li",self.requestModel.queryType,self.requestModel.sortType];
    
    if (self.requestModel.queryType == SCWitQueryTypeSearch) {
        [key appendFormat:@"_%@", self.requestModel.queryStr];
        
    }
    return key;
}

- (void)getAggregateStore:(NSInteger)page showCache:(BOOL)showCache showHud:(BOOL)showHud completion:(SCHttpRequestCompletion)completion
{
    NSString *key = [self getCacheKey];
    self.currentKey = key;
    
    SCWitStoreCacheModel *cacheModel = self.storeDict[key];
    
    if (showCache && cacheModel) {
        self.currentCacheModel = cacheModel;
        if (completion) {
            completion(nil);
        }
        
    }else {
        [self requestAggregateStoreData:page showHud:showHud completion:completion];
    }

}

//门店
- (void)requestAggregateStoreData:(NSInteger)page showHud:(BOOL)showHud completion:(SCHttpRequestCompletion)completion
{
    self.requestModel.page = page;
    NSDictionary *param = [self.requestModel getParams];
    
    NSString *cacheKey = [self getCacheKey];
    
    if (showHud) {
        [self showLoading];
    }

    [SCRequestParams shareInstance].requestNum = @"apollo.getAggregateStore";
    [SCNetworkManager POST:SC_AGGREGATE_STORE parameters:param success:^(id  _Nullable responseObject) {
        
        NSString *resultKey = @"result";

        if (![SCNetworkTool checkResult:responseObject key:resultKey forClass:NSArray.class completion:nil]) {
            if ([self.currentKey isEqualToString:cacheKey]) {
                self.currentCacheModel = nil;
            }
            if (completion) {
                completion(@"获取失败");
            }
            
            return;
        }
        
        NSDictionary *result = responseObject[A_RESULT];
        NSInteger totalPageCount = [result safeIntegerValueForKey:@"pageCount"];
        
        NSArray *data = result[resultKey];
        
        NSMutableArray *models = [self handleStoreResult:data];
        
        if (page == 1 && self.requestModel.queryType == SCWitQueryTypeNear && self.requestModel.sortType == SCWitSortTypeNear && models.count > 0 ) {
            //更新最近门店信息
            self.nearStoreModel = models.firstObject;
        }

        //做缓存
        SCWitStoreCacheModel *cacheModel = self.storeDict[cacheKey];
        
        if (!cacheModel) {
            cacheModel = [SCWitStoreCacheModel new];
            self.storeDict[cacheKey] = cacheModel;
        }
        
        if (page == 1) {
            [cacheModel.storeList removeAllObjects];
        }
        
        [cacheModel.storeList addObjectsFromArray:models];
        cacheModel.hasMoreData = page < totalPageCount;
        cacheModel.page = page;
        
        if ([self.currentKey isEqualToString:cacheKey]) {
            self.currentCacheModel = cacheModel;
            if (completion) {
                completion(nil);
            }
        }

    } failure:^(NSString * _Nullable errorMsg) {
        if ([self.currentKey isEqualToString:cacheKey]) {
            self.currentCacheModel = nil;
        }
        
        if (completion) {
            completion(errorMsg);
        }
    }];
}


- (NSMutableArray *)handleStoreResult:(NSArray *)result
{
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:result.count];
    for (NSDictionary *dict in result) {
        if (!VALID_DICTIONARY(dict)) {
            continue;
        }
        SCWitStoreModel *model = [SCWitStoreModel yy_modelWithDictionary:dict];
        //计算高度
        model.rowHeight = [SCWitStoreCell calculateRowHeight:model];
        
        [mulArr addObject:model];
    }
    
    //请求优惠券信息
    [self requestStoCou:mulArr];
    //请求排队人数信息
    [self requestQueueInfo:mulArr];
    
    return mulArr;
}


- (void)requestStoCou:(NSMutableArray <SCWitStoreModel *> *)storeList
{
    NSMutableArray *storeIds = [NSMutableArray arrayWithCapacity:storeList.count];
    for (SCWitStoreModel *model in storeList) {
        if (model.cou && VALID_STRING(model.storeId)) {
            [storeIds addObject:model.storeId];
        }
    }
    
    if (storeIds.count == 0) {
        return;
    }
 
    NSDictionary *param = @{@"storeId": storeIds};
    
    [SCRequestParams shareInstance].requestNum = @"apollo.batchQueryStoCou";
    [SCNetworkManager POST:SC_STO_COU parameters:param success:^(id  _Nullable responseObject) {
        
        NSString *key = @"stoCouMap";
        if (![SCNetworkTool checkResult:responseObject key:key forClass:NSDictionary.class completion:nil]) {
            return;
        }
        
        NSDictionary *stoCouMap = responseObject[A_RESULT][key];
        
        for (SCWitStoreModel *model in storeList) {
            if (![stoCouMap.allKeys containsObject:model.storeId]) {
                continue;
            }
            NSArray *couList = stoCouMap[model.storeId];
            
            if (!VALID_ARRAY(couList)) {
                continue;
            }
            
            NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:couList.count];
            for (NSDictionary *dict in couList) {
                SCWitCouponModel *couModel = [SCWitCouponModel yy_modelWithDictionary:dict];
                [mulArr addObject:couModel];
            }
            model.couponList = mulArr.copy;
            
            if (model.cell) {
                model.cell.model = model;
            }

        }
        

        
    } failure:^(NSString * _Nullable errorMsg) {
        
    }];
}

- (void)requestQueueInfo:(NSMutableArray <SCWitStoreModel *> *)storeList
{
    for (SCWitStoreModel *model in storeList) {
        if (!(model.line && VALID_STRING(model.storeCode))) {
            continue;
        }
        
        [SCRequestParams shareInstance].requestNum = @"apollo.qryHallQueueInfo";
        [SCNetworkManager POST:SC_QUEUE_INFO
                    parameters:@{@"hallId": model.storeCode}
                       success:^(id  _Nullable responseObject) {
            if ([SCNetworkTool checkResult:responseObject key:nil forClass:NSDictionary.class completion:nil]) {
                NSDictionary *result = responseObject[A_RESULT];
                SCWitQueueInfoModel *queueModel = [SCWitQueueInfoModel yy_modelWithDictionary:result];
                model.queueInfoModel = queueModel;
                
                if (model.cell) {
                    model.cell.model = model;
                }
                if (model.headerView) {
                    model.headerView.model = model;
                }
            }
        }
                       failure:^(NSString * _Nullable errorMsg) {
            
        }];
        
    }

}


//推荐商品
- (void)requestRecommendGoods:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    if (!self.nearStoreModel || !VALID_STRING(self.nearStoreModel.storeCode)) {
        return;
    }
    
    NSDictionary *param = @{@"orgId": self.nearStoreModel.storeCode,
                            @"page":@{@"pageNum": @1,
                                      @"pageSize": @3},
                            @"phoneNum": ([SCUserInfo currentUser].phoneNumber ?: @"")};
    
    [SCRequestParams shareInstance].requestNum = @"apollo.pageQueryGoodsTerminal";
    [SCNetworkManager POST:SC_GOODS_TERMINAL parameters:param success:^(id  _Nullable responseObject) {
        NSString *key = @"result";
        if (![SCNetworkTool checkResult:responseObject key:key forClass:NSArray.class failure:failure]) {
            return;
        }
        NSArray *result = responseObject[A_RESULT][key];
        
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:result.count];
        for (NSDictionary *dict in result) {
            if (!VALID_DICTIONARY(dict)) {
                continue;
            }
            SCWitStoreGoodModel *model = [SCWitStoreGoodModel yy_modelWithDictionary:dict];
            [mulArr addObject:model];
        }
        self.goodsList = mulArr.copy;
        if (success) {
            success(nil);
        }
        
    } failure:failure];
}

//推荐门店
//- (void)requestProfessionalStore:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
- (void)requestProfessionalStore
{
    NSDictionary *param = @{@"location": @{@"lat": [SCLocationService sharedInstance].latitude ?: @"",
                                           @"lon": [SCLocationService sharedInstance].longitude ?: @""},
                            @"page": @{@"pageNum": @1,
                                       @"pageSize": @(kCountCurPage)},
                            @"queryType": @"1"};
    
    [SCRequestParams shareInstance].requestNum = @"apollo.getProfessionalStore";
    [SCNetworkManager POST:SC_PROFESSIONAL_STORE parameters:param success:^(id  _Nullable responseObject) {
        NSString *key = @"result";
        if (![SCNetworkTool checkResult:responseObject key:key forClass:NSArray.class failure:nil]) {
            return;
        }

        NSArray *result = responseObject[A_RESULT][key];
        
        self.professionalList = [self handleStoreResult:result].copy;
        
    } failure:^(NSString * _Nullable errorMsg) {
        
    }];
}

//立即取号
- (void)requestVouchNumber:(SCWitStoreModel *)model success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    NSDictionary *param = @{@"hallId": model.storeCode,
                            @"hallName": model.storeName,
                            @"vouchNumber": ([SCUserInfo currentUser].phoneNumber ?: @""),
                            @"vouchType": @"01",
                            @"generateType": @"3"};
    
    [SCRequestParams shareInstance].requestNum = @"apollo.getByVouchNumber";
    [SCNetworkManager POST:SC_VOUCH_NUMBER parameters:param success:^(id  _Nullable responseObject) {
        if (![SCNetworkTool checkResult:responseObject key:nil forClass:NSDictionary.class failure:failure]) {
            return;
        }
        NSDictionary *result = responseObject[A_RESULT];
        SCWitQueueInfoModel *queueModel = [SCWitQueueInfoModel yy_modelWithDictionary:result];
        model.queueInfoModel = queueModel;
        if (success) {
            success(nil);
        }
        
        
    } failure:failure];
}

- (BOOL)showProfessionalList
{
    return self.requestModel.queryType == SCWitQueryTypeVIP && self.professionalList.count > 0;;
}

- (SCWitRequestModel *)requestModel
{
    if (!_requestModel) {
        _requestModel = [SCWitRequestModel new];
    }
    return _requestModel;
}

- (NSMutableDictionary<NSString *,SCWitStoreCacheModel *> *)storeDict
{
    if (!_storeDict) {
        _storeDict = [NSMutableDictionary dictionary];
    }
    return _storeDict;
}

@end




@implementation SCWitRequestModel

- (void)setBusiRegCityCode:(NSString *)busiRegCityCode
{
    _busiRegCityCode = busiRegCityCode;
    
    self.queryType = SCWitQueryTypeNear;
    self.sortType  = SCWitSortTypeNear;
    self.queryStr  = nil;
}

- (void)setQueryType:(SCWitQueryType)queryType
{
    _queryType = queryType;

    if (queryType == SCWitQueryTypeSearch) {
        self.sortType = SCWitSortTypeNear;
    }

}

- (NSDictionary *)getParams
{
    NSString *busiRegCityCode = VALID_STRING(self.busiRegCityCode) ? self.busiRegCityCode : ([SCLocationService sharedInstance].cityCode);
    
    NSDictionary *page        = @{@"pageNum": NSStringFormat(@"%li",(self.page > 0 ? self.page : 1)),
                                  @"pageSize": NSStringFormat(@"%i",kCountCurPage)};
    
    
    NSMutableDictionary *param = @{@"busiRegCityCode": busiRegCityCode,
                                   @"page": page,
                                   @"queryType": NSStringFormat(@"%li",self.queryType),
                                   @"sortType" : NSStringFormat(@"%li",self.sortType)}.mutableCopy;
    
    
    NSString *phoneNum = [SCUserInfo currentUser].phoneNumber;
    if (VALID_STRING(phoneNum)) {
        param[@"phoneNum"] = phoneNum;
    }
    
    if (self.queryType == SCWitQueryTypeSearch) {
        param[@"queryStr"] = self.queryStr ?: @"";
        
    }
    
    NSString *lon = [SCLocationService sharedInstance].longitude;
    NSString *lat = [SCLocationService sharedInstance].latitude;
    if (VALID_STRING(lon) && VALID_STRING(lat)) {
        NSDictionary *location    =  @{@"lon":[SCLocationService sharedInstance].longitude,
                                       @"lat":[SCLocationService sharedInstance].latitude};
        param[@"location"] = location;
    }

    return param;
}


@end



@implementation SCWitStoreCacheModel

- (NSMutableArray<SCWitStoreModel *> *)storeList
{
    if (!_storeList) {
        _storeList = [NSMutableArray array];
    }
    return _storeList;
}

@end
