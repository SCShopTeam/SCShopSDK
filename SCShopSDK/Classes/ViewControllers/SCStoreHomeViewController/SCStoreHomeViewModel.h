//
//  SCStoreHomeViewModel.h
//  shopping
//
//  Created by gejunyu on 2021/3/8.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCTenantInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCStoreHomeViewModel : NSObject

@property (nonatomic, strong, readonly) SCTenantInfoModel *tenantInfo;
@property (nonatomic, strong, readonly) NSMutableArray<SCCommodityModel *> * commodityList;
@property (nonatomic, assign, readonly) BOOL hasNoData;

- (void)requestTenantInfo:(NSString *)tenantNum completion:(SCHttpRequestCompletion)completion;

- (void)requestCommodityList:(NSString *)tenantNum sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum completion:(SCHttpRequestCompletion)completion;


- (nullable NSString *)getOnlineServiceUrl:(NSString *)tenantNum;

@end

NS_ASSUME_NONNULL_END
