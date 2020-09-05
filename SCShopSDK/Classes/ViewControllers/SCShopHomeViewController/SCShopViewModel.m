//
//  SCShopViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCShopViewModel.h"

@interface SCShopViewModel ()
@property (nonatomic, strong) SCTenantInfoModel *tenantInfo;
@property (nonatomic, strong) NSMutableArray <SCCommodityModel *> *commodityList;
@property (nonatomic, assign) BOOL hasMoreData;
@end

@implementation SCShopViewModel


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

- (void)requestCommodityList:(NSString *)tenantNum sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum completion:(nonnull SCHttpRequestCompletion)completion
{
    
    [SCCategoryViewModel requestCommoditiesWithTypeNum:nil brandNum:nil tenantNum:tenantNum categoryName:nil cityNum:nil isPreSale:NO sort:sort sortType:sortType pageNum:pageNum success:^(NSMutableArray<SCCommodityModel *> * _Nonnull commodityList) {
        
        if (pageNum == 1) {
            [self.commodityList removeAllObjects];
        }
        
        [self.commodityList addObjectsFromArray:commodityList];
        
        self.hasMoreData = commodityList.count >= kCountCurPage;
        
        
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
