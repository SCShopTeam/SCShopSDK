//
//  SCHomeStoreProtocol.h
//  shopping
//
//  Created by gejunyu on 2021/3/25.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#ifndef SCHomeStoreProtocol_h
#define SCHomeStoreProtocol_h

@class SCHomeGoodsModel;
@class SCHomeActivityModel;

@protocol SCHomeStoreProtocol <NSObject>

//电话
- (void)call;
//客服
- (void)pushToService;
//店铺主页
- (void)pushToStorePage;
//更多热销
- (void)pushToMoreGoods;
//跳转本店优惠商品详情
- (void)pushToGoodDetail:(NSInteger)index;
//跳转商品页
- (void)pushToGoodsList:(SCHomeActivityModel *)model index:(NSInteger)index;
//跳转活动链接
- (void)pushToActivityPage:(SCHomeActivityModel *)model;
//跳转直播
- (void)pushToLivePage:(SCHomeActivityModel *)model;

@end


#endif /* SCHomeStoreProtocol_h */
