//
//  SCStoreHomeViewModel.m
//  shopping
//
//  Created by gejunyu on 2021/3/8.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCStoreHomeViewModel.h"
#import "NSData+SCBase64.h"

@interface SCStoreHomeViewModel ()
@property (nonatomic, strong) SCTenantInfoModel *tenantInfo;
@property (nonatomic, strong) NSMutableArray<SCCommodityModel *> * commodityList;
@property (nonatomic, assign) BOOL hasNoData;

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


- (void)requestCommodityList:(NSString *)tenantNum sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum completion:(nonnull SCHttpRequestCompletion)completion
{
    [SCRequest requestCommoditiesWithTypeNum:nil brandNum:nil tenantNum:tenantNum categoryName:nil cityNum:nil isPreSale:NO sort:sort sortType:sortType pageNum:pageNum success:^(NSArray<SCCommodityModel *> * _Nonnull commodityList, BOOL hasNoData) {
        if (pageNum == 1) {
            [self.commodityList removeAllObjects];
        }
        
        [self.commodityList addObjectsFromArray:commodityList];
        
        self.hasNoData = hasNoData;
        
        if (completion) {
            completion(nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
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

- (NSMutableArray<SCCommodityModel *> *)commodityList
{
    if (!_commodityList) {
        _commodityList = [NSMutableArray array];
    }
    return _commodityList;
}

@end
