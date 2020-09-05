//
//  SCShopViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCategoryViewModel.h"
#import "SCTenantInfoModel.h"
#import "SCCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCShopViewModel : NSObject

@property (nonatomic, strong, readonly) SCTenantInfoModel *tenantInfo;
@property (nonatomic, strong, readonly) NSMutableArray <SCCommodityModel *> *commodityList;

@property (nonatomic, assign, readonly) BOOL hasMoreData;

- (void)requestTenantInfo:(NSString *)tenantNum completion:(SCHttpRequestCompletion)completion;

- (void)requestCommodityList:(NSString *)tenantNum sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum completion:(SCHttpRequestCompletion)completion;
@end


NS_ASSUME_NONNULL_END
