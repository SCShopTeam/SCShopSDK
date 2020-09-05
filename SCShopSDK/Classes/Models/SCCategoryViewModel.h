//
//  SCCategoryViewModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/6.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCategoryModel.h"
#import "SCCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SCCategorySortKey) {
    SCCategorySortKeyRecommand, //推荐
    SCCategorySortKeyTime,      //上新
    SCCategorySortKeyPrice,     //价格
    SCCategorySortKeySale,      //销量
    
};

typedef NS_ENUM(NSInteger, SCCategorySortType) {
    SCCategorySortTypeAsc,    //正序
    SCCategorySortTypeDesc    //倒序
};

typedef void(^SCCategoryBlock)(NSArray <SCCategoryModel *> *categoryList);
typedef void(^SCCommodityBlock)(NSMutableArray <SCCommodityModel *> *commodityList);

@interface SCCategoryViewModel : NSObject

//分类列表
+ (void)requestCategory:(SCCategoryBlock)successBlock failure:(SCHttpRequestFailed)failureBlock;

//品类列表
+ (void)requestCommoditiesWithTypeNum:(nullable NSString *)typeNum brandNum:(nullable NSString *)brandNum tenantNum:(nullable NSString *)tenantNum categoryName:(nullable NSString *)categoryName cityNum:(nullable NSString *)cityNum isPreSale:(BOOL)isPreSale sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum success:(SCCommodityBlock)successBlock failure:(SCHttpRequestFailed)failureBlock;

//为你推荐
+ (void)requestRecommend:(SCCommodityBlock)successBlock failure:(SCHttpRequestFailed)failureBlock;

@end

NS_ASSUME_NONNULL_END
