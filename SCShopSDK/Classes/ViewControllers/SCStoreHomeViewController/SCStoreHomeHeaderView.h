//
//  SCStoreHomeHeaderView.h
//  shopping
//
//  Created by gejunyu on 2020/7/23.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTenantInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCStoreHomeHeaderView : UICollectionReusableView

@property (nonatomic, strong) SCTenantInfoModel *tenantInfo;

@property (nonatomic, copy) void (^bannerBlock)(SCTenantInfoModel *tenantInfo);

@end

NS_ASSUME_NONNULL_END
