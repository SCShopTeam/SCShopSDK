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

@property (nonatomic, assign) BOOL isTouchRequesting;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *topList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *bannerList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *gridList;
@property (nonatomic, strong) NSArray <SCHomeTouchModel *> *adList;                     //广告
@property (nonatomic, strong) NSDictionary <NSNumber *, SCHomeTouchModel *> *popupDict; //弹窗

@property (nonatomic, assign) BOOL isStoreRequesting;
@property (nonatomic, strong) SCHomeStoreModel *recommendStoreModel;                    //推荐门店
@property (nonatomic, strong) NSArray <SCHomeStoreModel *> *goodStoreList;              //发现好店

@property (nonatomic, assign) BOOL isCategoryRequesting; //是否正在请求分类
@property (nonatomic, strong) NSArray <SCCategoryModel *> *categoryList;                //分类

@property (nonatomic, assign) BOOL isCommodityRequesting;
@property (nonatomic, strong) NSMutableArray<SCCommodityModel *> *commodityList;
@property (nonatomic, assign) BOOL hasNoData;


@end

@implementation SCHomeViewModel

#pragma mark -检测用户是否发生变化
- (BOOL)userHasChanged
{
    SCUserInfo *currentUser = [SCUserInfo currentUser];
    
    NSString *cuPhone = currentUser.phoneNumber;
    BOOL cuLogin = currentUser.isLogin;
    
    BOOL hasChanged =  _lastUserInfo && (currentUser.phoneNumber != _lastUserInfo.phoneNumber || currentUser.isLogin != _lastUserInfo.isLogin);
    
    _lastUserInfo = currentUser;
    
    return hasChanged;
    
    
}

#pragma mark -触点相关
- (void)requestTouchData:(UIViewController *)viewController success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    if (_isTouchRequesting) {
        return;
    }
    
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];

    if (![manager.delegate respondsToSelector:@selector(scADTouchDataFrom:backData:)]) {
        if (failure) {
            failure(@"delegate null");
        }
        return;
    }
    
    _isTouchRequesting = YES;

    [manager.delegate scADTouchDataFrom:viewController backData:^(id  _Nonnull touchData) {
        self.isTouchRequesting = NO;
        
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

#pragma mark -店铺
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

#pragma mark -弹窗触点
//触点展示
- (void)touchShow:(SCHomeTouchModel *)model
{
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    
    if ([manager.delegate respondsToSelector:@selector(scADTouchShow:)]) {
        NSDictionary *dict = [model getParams];
        [manager.delegate scADTouchShow:dict];
    }
}

//触点点击
- (void)touchClick:(SCHomeTouchModel *)model
{
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    
    if ([manager.delegate respondsToSelector:@selector(scADTouchClick:)]) {
        NSDictionary *dict = [model getParams];
        [manager.delegate scADTouchClick:dict];
    }
}

#pragma mark -分类
- (void)requestCategoryList:(SCHttpRequestCompletion)completion
{
    self.isCategoryRequesting = YES;
    [SCRequest requestCategory:^(NSArray<SCCategoryModel *> * _Nonnull categoryList) {
        self.isCategoryRequesting = YES;
        
        self.categoryList = categoryList;
        
        if (categoryList.count > 0) {
            self.categoryList.firstObject.selected = YES; //默认第一个选中
            
        }

        
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

#pragma mark -商品
- (void)requestCommodityListData:(NSString *)typeNum pageNum:(NSInteger)pageNum completion:(SCHttpRequestCompletion)completion
{
    if (_isCommodityRequesting) {
        return;
    }
    
    _isCommodityRequesting = YES;
    
    [SCRequest requestCommoditiesWithTypeNum:(typeNum?:@"") brandNum:nil tenantNum:nil categoryName:nil cityNum:nil isPreSale:NO sort:SCCategorySortKeySale sortType:SCCategorySortTypeDesc pageNum:pageNum success:^(NSArray<SCCommodityModel *> * _Nonnull commodityList, NSArray * _Nonnull originDatas) {
        self.isCommodityRequesting = NO;
        
        if (pageNum == 1) {
            [self.commodityList removeAllObjects];
        }
        
        [self.commodityList addObjectsFromArray:commodityList];
        self.hasNoData = commodityList.count < kCountCurPage;
        
        if (completion) {
            completion(nil);
        }
        
        
    } failure:^(NSString * _Nullable errorMsg) {
        self.isCommodityRequesting = NO;
        
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
