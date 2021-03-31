//
//  SCHomeViewModel.h
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCHomeTouchModel.h"
#import "SCGoodStoresModel.h"
#import "SCCategoryModel.h"
#import "SCCommodityModel.h"
#import "SCHomeStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeViewModel : NSObject

/*触点接口*/
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *topList;             //顶部宫格
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *bannerList;          //轮播图
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *gridList;            //8宫格
@property (nonatomic, assign, readonly) CGFloat gridRowHeight;                             //宫格楼层高度
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *adList;              //广告
@property (nonatomic, strong, readonly) NSArray <SCHomeTouchModel *> *popupList;           //弹窗
/*门店接口*/
@property (nonatomic, strong ,readonly) SCHomeStoreModel *storeModel;                      //推荐门店
@property (nonatomic, assign, readonly) CGFloat storeRowHeight;                            //门店楼层高度
/*好店接口*/
@property (nonatomic, strong, readonly) NSArray <SCGoodStoresModel *> *goodStoreList;      //发现好店
@property (nonatomic, assign, readonly) CGFloat goodStoresRowHeight;                       //好店楼层高度
/*分类接口*/
@property (nonatomic, strong, readonly) NSArray <SCCategoryModel *> *categoryList;         //分类
/*商品接口*/
@property (nonatomic, strong, readonly) NSMutableArray<SCCommodityModel *> *commodityList; //商品
@property (nonatomic, assign, readonly) BOOL hasNoData;

//检测登录用户是否发生变化
- (BOOL)userHasChanged;

//触点
- (void)requestTouchData:(UIViewController *)viewController success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure;

//推荐门店
- (void)requestRecommendStoreData:(SCHttpRequestCompletion)completion;

//发现好店
- (void)requestGoodStoreList:(SCHttpRequestCompletion)completion;

//分类
- (void)requestCategoryList:(SCHttpRequestCompletion)completion;

//商品
- (void)requestCommodityListData:(NSString *)typeNum pageNum:(NSInteger)pageNum completion:(SCHttpRequestCompletion)completion;

@end

NS_ASSUME_NONNULL_END
