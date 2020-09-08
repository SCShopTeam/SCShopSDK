//
//  SCStoreHomeViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCategoryViewModel.h"
#import "SCTenantInfoModel.h"
#import "SCCommodityModel.h"
@class SCStoreHomeCacheModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCStoreHomeViewModel : NSObject

@property (nonatomic, strong, readonly) SCTenantInfoModel *tenantInfo;
@property (nonatomic, weak, readonly) SCStoreHomeCacheModel *currentCacheModel; 

- (void)requestTenantInfo:(NSString *)tenantNum completion:(SCHttpRequestCompletion)completion;

- (void)getCommodityList:(NSString *)tenantNum sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum showCache:(BOOL)showCache completion:(SCHttpRequestCompletion)completion;

@end


@interface SCStoreHomeCacheModel : NSObject
@property (nonatomic, strong) NSMutableArray <SCCommodityModel *> *commodityList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL hasMoreData;
@end

NS_ASSUME_NONNULL_END
