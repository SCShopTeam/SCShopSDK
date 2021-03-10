//
//  SCHomeSubItemView.h
//  shopping
//
//  Created by gejunyu on 2021/3/3.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCategoryModel.h"
@class SCCommodityModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeSubItemView : UIView
@property (nonatomic, strong) SCCategoryModel *model;

@property (nonatomic, copy) void (^selectBlock)(SCCommodityModel *model);

- (void)refresh:(BOOL)showLoading;

@end

NS_ASSUME_NONNULL_END
