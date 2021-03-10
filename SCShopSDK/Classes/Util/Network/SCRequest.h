//
//  SCRequest.h
//  shopping
//
//  Created by zhangtao on 2020/7/29.
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
    SCCategorySortTypeDesc,  //倒序
    SCCategorySortTypeAsc    //升序
};
//

typedef void(^SCCategoryBlock)(NSArray <SCCategoryModel *> *categoryList);

typedef void(^SCCommodityBlock)(NSArray <SCCommodityModel *> *commodityList, NSArray *originDatas);


@interface SCRequest : NSObject

//登录1
+(void)scLoginResultBlock:(void(^_Nullable)(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg))callBack;

//省市县列表
+(void)scAreaListWithLevel:(NSString *)level adminNum:(NSString*)adminNum block:(void(^)(BOOL success, NSDictionary *objDic, NSString *errMsg))callBack;

//购物车新增/修改
+ (void)requestCartMerge:(nullable NSString *)cartItemNum itemNum:(nonnull NSString *)itemNum itemQuantity:(NSInteger)itemQuantity success:(nullable SCHttpRequestSuccess)success failure:(nullable SCHttpRequestFailed)failure;

//购物车 商品删除
+ (void)requestCartDelete:(nonnull NSString *)cartItemNum itemNum:(nonnull NSString *)itemNum success:(nullable SCHttpRequestSuccess)success failure:(nullable SCHttpRequestFailed)failure;

//用户 收藏商品 新增
+ (void)requestFavoriteAdd:(nonnull NSString *)itemNum success:(nullable SCHttpRequestSuccess)success failure:(nullable SCHttpRequestFailed)failure;

//用户 收藏商品 删除
+ (void)requestFavoriteDelete:(nonnull NSString *)favNum itemNum:(NSString *)itemNum success:(nullable SCHttpRequestSuccess)success failure:(nullable SCHttpRequestFailed)failure;

//收货地址列表
+(void)scAddressList:(void(^_Nullable)(BOOL success, NSArray * _Nullable objArr, NSString * _Nullable errMsg))callBack;
//收货地址 详情
+(void)scAddressDetail:(NSString *_Nullable)addressNum block:(void(^_Nullable)(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg))callBack;

//收货地址 新增/修改
+(void)scAddressEdit:(NSDictionary *_Nullable)addressDic block:(void(^_Nullable)(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg))callBack;
//收货地址 删除
+(void)scAddressDelete:(NSString *_Nullable)addressNum block:(void(^_Nullable)(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg))callBack;


//分类查询（大类）
//+(void)scCategoryListBlock:(void (^)(BOOL, NSArray * _Nullable, NSString * _Nullable))callBack;
+ (void)requestCategory:(SCCategoryBlock)successBlock failure:(SCHttpRequestFailed)failureBlock;


//品类列表查询
//+(void)scCategoryCommoditiesList:(NSDictionary *_Nullable)param block:(void(^_Nullable)(BOOL success, NSDictionary * _Nullable objArr, NSString * _Nullable errMsg))callBack;
+ (void)requestCommoditiesWithTypeNum:(nullable NSString *)typeNum brandNum:(nullable NSString *)brandNum tenantNum:(nullable NSString *)tenantNum categoryName:(nullable NSString *)categoryName cityNum:(nullable NSString *)cityNum isPreSale:(BOOL)isPreSale sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum success:(SCCommodityBlock)successBlock failure:(SCHttpRequestFailed)failureBlock;


//为你推荐    品类列表封装接口
+ (void)requestRecommend:(SCCommodityBlock)successBlock failure:(SCHttpRequestFailed)failureBlock;


//商城订单列表
+(void)scMyOrderList_scParam:(NSDictionary *)param block:(void(^_Nullable)(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg))callBack;

//阿波罗订单列表
+(void)mdMyOrderList_mdParam:(NSDictionary *)param block:(void(^_Nullable)(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg))callBack;

@end

NS_ASSUME_NONNULL_END
