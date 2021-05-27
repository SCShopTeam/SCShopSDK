//
//  SCHomeStoreModel.h
//  shopping
//
//  Created by gejunyu on 2021/3/16.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCHomeLightSpotModel;
@class SCHomeCouponModel;
@class SCHomeGoodsModel;
@class SCHomeActivityModel;

typedef NS_ENUM(NSInteger, SCHomeActivityType) {
    SCHomeActivityTypeLive,       //直播
    SCHomeActivityTypeLimited,    //秒杀
    SCHomeActivityTypePresale,    //预售
    SCHomeActivityTypeGroup,      //拼团
    SCHomeActivityTypeActivity    //活动
};


NS_ASSUME_NONNULL_BEGIN

@interface SCHomeStoreModel : NSObject
//接口1
@property (nonatomic, copy) NSString *storeAddress; //地址
@property (nonatomic, copy) NSString *storeId;      //门店id
@property (nonatomic, copy) NSString *storeCode;    //门店编码
@property (nonatomic, copy) NSString *storeName;    //门店名称
@property (nonatomic, copy) NSString *storeLink;    //链接
@property (nonatomic, copy) NSString *contactPhone; //门店电话
@property (nonatomic, assign) NSInteger distance;   //距离  单位：米
@property (nonatomic, copy) NSArray <SCHomeLightSpotModel *> *lightspotList; //亮点合集
@property (nonatomic, copy) NSArray <SCHomeCouponModel *> *couponList;       //优惠信息集合
//接口2
@property (nonatomic, copy) NSString *serviceUrl;   //客服
//接口3.1
@property (nonatomic, copy) NSArray <SCHomeGoodsModel *> *topGoodsList;      //本店优惠
//接口3.2
@property (nonatomic, copy) NSArray <NSArray <SCHomeActivityModel *> *> *activityList; //活动

//自定义
@property (nonatomic, assign) BOOL locationError;

- (void)parsingTopGoodsModelsFromData:(NSDictionary *)data;
- (void)parsingActivityModelsFromData:(NSDictionary *)data;

@end
    

//亮点
@interface SCHomeLightSpotModel : NSObject
@property (nonatomic, copy) NSString *lightSpotName;  //名称
@property (nonatomic, copy) NSString *lightSpotId;    //id

@end

//优惠券
@interface SCHomeCouponModel : NSObject
@property (nonatomic, copy) NSString *couCateCode;  //优惠类型
@property (nonatomic, copy) NSString *couId;        //优惠id
@property (nonatomic, copy) NSString *couName;      //优惠名称
@property (nonatomic, copy) NSString *limitDesc;    //优惠描述

@end


//几种model合并为一个，否则后续相关逻辑较为复杂
@interface SCHomeActivityModel : NSObject
//共有属性
@property (nonatomic, copy) NSString *name;       //名称
@property (nonatomic, copy) NSString *topic;      //主题
@property (nonatomic, copy) NSString *sellPoint;  //卖点
@property (nonatomic, copy) NSString *link;       //跳转地址:直播房间地址、秒杀列表地址、拼团列表地址、预售列表地址、活动链接
@property (nonatomic, copy) NSString *imageUrl;   //图片地址:直播房间图片地址、活动图片地址
@property (nonatomic, copy) NSString *startTime;  //开始时间:直播、秒杀
@property (nonatomic, copy) NSString *endTime;    //结束时间:直播、秒杀
@property (nonatomic, copy) NSArray <SCHomeGoodsModel *> *goodsList;  //商品列表

//单独属性
@property (nonatomic, assign) NSInteger liveAudience;     //直播：观众人数
@property (nonatomic, assign) NSInteger groupPersonCount; //拼团：成团人数
@property (nonatomic, copy) NSString *offerType;          //预售：预售模式
@property (nonatomic, assign) NSInteger preferentialFee;  //预售：抵扣、膨胀金额
@property (nonatomic, copy) NSString *activityId;         //活动：活动id
//@property (nonatomic, copy) NSString *orgAppId;           //直播：小程序id

//自定义
@property (nonatomic, assign) SCHomeActivityType type; //类型

+ (instancetype)parsingModelFromData:(NSDictionary *)data type:(SCHomeActivityType)type;

@end

//商品
@interface SCHomeGoodsModel : NSObject  //
@property (nonatomic, copy) NSString *goodsId;            //商品id
@property (nonatomic, copy) NSString *goodsCode;          //商品编码
@property (nonatomic, copy) NSString *storeId;            //门店Id
@property (nonatomic, copy) NSString *storeCode;          //门店编码
@property (nonatomic, copy) NSString *goodsName;          //商品名称
@property (nonatomic, copy) NSString *goodsLabel;         //标签图片地址
@property (nonatomic, copy) NSString *labelName;          //标签名称
@property (nonatomic, assign) NSInteger wholesalePrice;   //零售价:厘
@property (nonatomic, assign) NSInteger guidePrice;       //划线价
@property (nonatomic, assign) NSInteger activityPrice;    //活动价格:厘
@property (nonatomic, copy) NSString *goodsPictureUrl;    //商品图片地址
@property (nonatomic, copy) NSString *supplierName;       //供货商名称
@property (nonatomic, copy) NSString *supplierCode;       //供货商编码
@property (nonatomic, assign) NSInteger displayQuantity;  //销量
@property (nonatomic, assign) NSInteger amount;           //库存数量
@property (nonatomic, copy) NSString *goodsDetailUrl;     //跳转地址
@property (nonatomic, copy) NSString *offerType;          //预售模式
@property (nonatomic, assign) NSInteger preferentialFee;  //抵扣、膨胀金额
@property (nonatomic, assign) NSInteger groupPersonCount; //成团人数

//自定义
@property (nonatomic, assign) SCHomeActivityType parentType; //上级model类型
@property (nonatomic, assign) BOOL hideOldPrice;

+ (NSArray <SCHomeGoodsModel *> *)parsingModelsFromData:(NSArray *)data parentType:(SCHomeActivityType)parentType;


@end


NS_ASSUME_NONNULL_END



/** 弃用  */
////直播
//@interface SCHomeLiveModel : NSObject
//@property (nonatomic, copy) NSString *livePlayerName;      //直播名称
//@property (nonatomic, copy) NSString *livePlayerTopic;     //直播主题
//@property (nonatomic, copy) NSString *livePlayerSellPoint; //直播卖点
//@property (nonatomic, assign) NSInteger liveAudience;      //观众人数
//@property (nonatomic, copy) NSString *livePlayerUrl;       //直播房间地址
//@property (nonatomic, copy) NSString *startTime;           //开始时间
//@property (nonatomic, copy) NSString *endTime;             //结束时间
//@property (nonatomic, copy) NSString *liveImageUrl;        //房间图片地址
//@property (nonatomic, copy) NSArray <SCHomeGoodsModel *> *liveGoodsList; //直播商品集合
//
//@end
//
////秒杀
//@interface SCHomeLimitedModel : NSObject
//@property (nonatomic, copy) NSString *limitedName;      //秒杀名称
//@property (nonatomic, copy) NSString *limitedTopic;     //秒杀主题
//@property (nonatomic, copy) NSString *limitedSellPoint; //秒杀卖点
//@property (nonatomic, copy) NSString *limitedUrl;       //秒杀列表地址
//@property (nonatomic, copy) NSString *startTime;        //开始时间
//@property (nonatomic, copy) NSString *endTime;          //结束时间
//@property (nonatomic, copy) NSArray <SCHomeGoodsModel *> *limitedGoodsList; //秒杀商品集合
//
//@end
//
////拼团
//@interface SCHomeGroupModel : NSObject
//@property (nonatomic, copy) NSString *groupName;          //拼团名称
//@property (nonatomic, copy) NSString *groupTopic;         //拼团主题
//@property (nonatomic, copy) NSString *groupSellPoint;     //拼团卖点
//@property (nonatomic, copy) NSString *groupUrl;           //拼团列表地址
//@property (nonatomic, assign) NSInteger groupPersonCount; //成团人数
//@property (nonatomic, copy) NSArray <SCHomeGoodsModel *> *groupGoodsList; //拼团商品集合
//
//@end
//
////预售
//@interface SCHomePresaleModel : NSObject
//@property (nonatomic, copy) NSString *presaleName;       //预售名称
//@property (nonatomic, copy) NSString *presaleTopic;      //预售主题
//@property (nonatomic, copy) NSString *presalePoint;      //预售卖点
//@property (nonatomic, copy) NSString *presaleUrl;        //预售列表地址
//@property (nonatomic, copy) NSString *offerType;         //预售模式
//@property (nonatomic, assign) NSInteger preferentialFee; //抵扣、膨胀金额
//@property (nonatomic, copy) NSArray <SCHomeGoodsModel *> *presaleGoodsList; //秒杀商品集合
//
//@end
//
////抽奖&优惠券
//@interface SCHomeActModel : NSObject
//@property (nonatomic, copy) NSString *activityId;     //活动id
//@property (nonatomic, copy) NSString *activityName;   //活动名称
//@property (nonatomic, copy) NSString *activityPoints; //活动卖点
//@property (nonatomic, copy) NSString *topic;          //主题
//@property (nonatomic, copy) NSString *activityLink;   //活动链接
//@property (nonatomic, copy) NSString *imageUrl;       //图片地址
//
//@end
