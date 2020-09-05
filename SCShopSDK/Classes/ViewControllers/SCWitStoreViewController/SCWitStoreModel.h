//
//  SCWitStoreModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/28.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCWitCouponModel;
@class SCWitQueueInfoModel;
@class SCWitStoreCell;
@class SCWitStoreHeaderView;

NS_ASSUME_NONNULL_BEGIN

@interface SCWitStoreModel : NSObject
@property (nonatomic, copy) NSString *storeId;             //门店ID "20011709"
@property (nonatomic, copy) NSString *storeName;           //门店名称  总部电子价签云货架体验厅（测试）
@property (nonatomic, copy) NSString *storeAddress;        //门店地址
@property (nonatomic, copy) NSString *storeCode;           //门店编码  "14004812"
@property (nonatomic, copy) NSString *storeLink;           //门店url
@property (nonatomic, assign) CGFloat lon;                 //经度
@property (nonatomic, assign) CGFloat lat;                 //纬度
@property (nonatomic, copy) NSString *geoDistance;         //距离 "0m"
@property (nonatomic, copy) NSString *busiRegProvinceCode; //省编码
@property (nonatomic, copy) NSString *busiRegCityCode;     //地市编码
@property (nonatomic, copy) NSString *busiRegCountyCode;   //区县编码
@property (nonatomic, copy) NSString *busiRegCityName;     //地市名称
@property (nonatomic, copy) NSString *busiRegCountyName;   //区县名称
@property (nonatomic, copy) NSString *contactPhone;        //联系人电话
@property (nonatomic, copy) NSString *actType;             //门店标签
@property (nonatomic, assign) BOOL line;                   //是否可排队
@property (nonatomic, assign) BOOL goods;                  //是否有商品
@property (nonatomic, assign) BOOL cou;                    //是否有优惠券
@property (nonatomic, assign) BOOL professional;           //是否是旗舰店

//未知
@property (nonatomic, copy) NSString *state;    // 0 1
@property (nonatomic, copy) NSString *channelIdStr;

//新接口关联数据
@property (nonatomic, strong) NSArray <SCWitCouponModel *> *couponList;
@property (nonatomic, strong) SCWitQueueInfoModel *queueInfoModel;

//自定义
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, weak) SCWitStoreCell *cell;
@property (nonatomic, weak) SCWitStoreHeaderView *headerView;

@end


@interface SCWitCouponModel : NSObject

@property (nonatomic, assign) NSInteger prdId;      //活动id
@property (nonatomic, copy) NSString *couDistId;    //优惠券id
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *couName;      //优惠券名称
@property (nonatomic, copy) NSString *nominalValue; //优惠券面值
@property (nonatomic, copy) NSString *limitMoney;   //使用限制金额
@property (nonatomic, copy) NSString *limitDesc;    //使用限制(满*可使用)描述
@property (nonatomic, copy) NSString *fullUseFlag;  //全额抵用标识  0:不限，1：限制

@end



@interface SCWitQueueInfoModel : NSObject

@property (nonatomic, copy) NSString *queue_NUMBER;
@property (nonatomic, copy) NSString *x_RESULTCODE;
@property (nonatomic, copy) NSString *x_RESULT_INFO;
@property (nonatomic, copy) NSString *current_TIME;

@end

NS_ASSUME_NONNULL_END
