//
//  SCStoreHomeViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCStoreHomeViewModel.h"
#import "NSData+SCBase64.h"

@interface SCStoreHomeViewModel ()
@property (nonatomic, strong) SCTenantInfoModel *tenantInfo;
@property (nonatomic, strong) NSMutableDictionary <NSString *, SCStoreHomeCacheModel *> *commodityDict;
@property (nonatomic, weak) SCStoreHomeCacheModel *currentCacheModel;
@property (nonatomic, copy) NSString *currentKey;

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

- (void)getCommodityList:(NSString *)tenantNum sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum showCache:(BOOL)showCache showHud:(BOOL)showHud completion:(SCHttpRequestCompletion)completion
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
        [self requestCommodityListData:tenantNum sort:sort sortType:sortType pageNum:pageNum showHud:showHud  completion:completion];
    }

}

- (void)requestCommodityListData:(NSString *)tenantNum sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum showHud:(BOOL)showHud completion:(nonnull SCHttpRequestCompletion)completion
{
    NSString *key = [self getCacheKeyFromSort:sort sortType:sortType];
    
    if (showHud) {
        UIViewController *vc = [SCUtilities currentViewController];
        [vc showLoading];
    }
    
    [SCCategoryViewModel requestCommoditiesWithTypeNum:nil brandNum:nil tenantNum:tenantNum categoryName:nil cityNum:nil isPreSale:NO sort:sort sortType:sortType pageNum:pageNum success:^(NSMutableArray<SCCommodityModel *> * _Nonnull commodityList) {
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
        if ([self.currentKey isEqualToString:key]) {
            self.currentCacheModel = nil;
        }
        
        if (completion) {
            completion(errorMsg);
        }
    }];
}

- (NSString *)getOnlineServiceUrl:(NSString *)tenantNum
{
    NSString *host = IS_RELEASE_ENVIRONMENT ? @"https://wx.apollojs.cn" : @"https://cnr.asiainfo.com";
    NSString *html = [NSString stringWithFormat:@"%@/xin_ucfront/uc_channel_access/h5webchat/webChat.html",host];
    
    NSString *tenantId = tenantNum ?: @"";
    NSString *skillId  = tenantId;
    NSString *phoneNum = [SCUserInfo currentUser].phoneNumber ?: @"";
    NSDictionary *param = @{@"tenantId": tenantId,
                            @"skillId": skillId,
                            @"phoneNum": phoneNum,
                            @"requestSource": @"2"}; //2表示掌厅
    //参数转data
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    if (!data) {
        return nil;
    }
    
    //base64加密
    NSString *paramBase64 = [data base64EncodedString];
    NSString *url = [NSString stringWithFormat:@"%@?param=%@",html,paramBase64];
    
    return url;
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
