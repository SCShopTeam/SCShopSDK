//
//  SCSCOrderModel.h
//  shopping
//
//  Created by zhangtao on 2020/8/12.
//  Copyright © 2020 jsmcc. All rights reserved.
//

//商城订单

#import <Foundation/Foundation.h>

@class SCOrderGoodsModel;

@interface SCSCOrderModel : NSObject

@property(nonatomic,assign) CGFloat orderMoney;// = 1000,
@property(nonatomic,strong)NSString *orderStatusName;// = "待支付",
@property(nonatomic,strong)NSString *payNum ;//= <null>,
@property(nonatomic,strong)NSString *invoiceStatus;// = <null>,
@property(nonatomic,strong)NSString *postCode;// = <null>,
@property(nonatomic,strong)NSString *icountyName;// = <null>,
@property(nonatomic,strong)NSString *tenantName;// = "默认租户/企业",
@property(nonatomic,strong)NSString *payTime;// = <null>,
@property(nonatomic,strong)NSString *icityId;// = <null>,
@property(nonatomic,strong)NSString *cityName;// = <null>,
@property(nonatomic,strong)NSString *provinceId;// = <null>,
@property(nonatomic,assign) CGFloat expressMoney;// = 0,
@property(nonatomic,strong)NSString *iprovinceName;// = <null>,
@property(nonatomic,strong)NSString *invoicePhone;// = <null>,
@property(nonatomic,strong)NSString *invoiceMail;// = <null>,
@property(nonatomic,strong)NSString *orderNum;// = "20200812100113",
@property(nonatomic,strong)NSString *closeMemo;// = <null>,
@property(nonatomic,strong)NSString *invoiceAddr;// = <null>,
@property(nonatomic,strong)NSString *icountyId;// = <null>,
@property(nonatomic,strong)NSString *userNum;// = <null>,
@property(nonatomic,strong)NSString *invoiceType;// = <null>,
@property(nonatomic,strong)NSString *closeManName;// = <null>,
@property(nonatomic,strong)NSString *shipList;// = <null>,
@property(nonatomic,strong)NSString *taxayer;// = <null>,
@property(nonatomic,strong)NSString *countyName;// = <null>,
@property(nonatomic,strong)NSString *receiptNum;// = <null>,
@property(nonatomic,strong)NSString *payType;// = <null>,
@property(nonatomic,strong)NSString *invoiceTitleType;// = <null>,
@property(nonatomic,strong)NSString *countyId;// = <null>,
@property(nonatomic,strong)NSString *provinceName;// = <null>,
@property(nonatomic,strong)NSString *orderStatus;// = "XSDD_DZF",
@property(nonatomic,strong)NSString *expressType;// = "01",
@property(nonatomic,strong)NSString *orderRemark;// = <null>,
@property(nonatomic,strong)NSString *cityId;// = <null>,
@property(nonatomic,strong)NSString *serviceList;// = <null>,
@property(nonatomic,strong)NSString *couponList;// = <null>,
@property(nonatomic,strong)NSString *receiptAddr;// = <null>,
@property(nonatomic,strong)NSString *userName;// = <null>,
@property(nonatomic,strong)NSString *invoiceContent;// = <null>,
@property(nonatomic,assign) CGFloat payMoney;// = 998,
@property(nonatomic,strong)NSString *closeTime;// = <null>,
@property(nonatomic,strong)NSString *userMobile;// = <null>,
@property(nonatomic,strong)NSString *orderTime;// = "2020-08-12 17:35:44",
@property(nonatomic,strong)NSString *iprovinceId;// = <null>,
@property(nonatomic,strong)NSString *isReturn;// = <null>,
@property(nonatomic,strong)NSString *orderType;// = "XSDD",
@property(nonatomic,strong)NSString *isReview;// = <null>,
@property(nonatomic,strong)NSString *icityName;// = <null>,
@property(nonatomic,strong)NSString *tenantNum;// = "1000000",
@property(nonatomic,strong)NSString *isDel ;//= <null>,
@property(nonatomic,strong)NSString *closeManCode;// = <null>,
@property(nonatomic,strong) NSArray <SCOrderGoodsModel *> *goodsList;// ;
@property(nonatomic,strong)NSString * receiptName;// = <null>,
@property(nonatomic,strong)NSString *invoiceTitle;// = <null>,


@end

@interface SCOrderGoodsModel : NSObject

@property(nonatomic,strong)NSString *tenantType;// = "1",
@property(nonatomic,strong)NSString *handleIdcard;// = <null>,
@property(nonatomic,assign) CGFloat discountMoney;// = 0,
@property(nonatomic,strong)NSString *goodsName;// = "SH商品003 测试 ",
@property(nonatomic,assign) CGFloat period;// = 0,
@property(nonatomic,strong)NSString *picUrl;// = <null>,
@property(nonatomic,strong)NSString *marketContent;// = <null>,
@property(nonatomic,assign) NSInteger goodsCount;// = 1,
@property(nonatomic,assign) CGFloat goodsPrice;// = 1000,
@property(nonatomic,assign) CGFloat goodsMoney;// = 1000,
@property(nonatomic,strong)NSString *levelName ;//= <null>,
@property(nonatomic,strong)NSString *goodsTitle;// = "测试删除",
@property(nonatomic,strong)NSString *marketName;// = <null>,
@property(nonatomic,strong)NSString *orderNum;// = "20200812100113",
@property(nonatomic,assign) CGFloat shipAmount;// = 0,
@property(nonatomic,strong)NSString *handleStatus;// = <null>,
@property(nonatomic,strong)NSString *goodsRemark ;//= <null>,
@property(nonatomic,strong)NSString *marketNum;// = <null>,
@property(nonatomic,strong)NSString *handleNum ;//= <null>,
@property(nonatomic,strong)NSString *handlePhone;// = <null>,
@property(nonatomic,assign) CGFloat isInstallment;// = 0,
@property(nonatomic,assign) CGFloat dealMoney;// = 1000,
@property(nonatomic,strong)NSString *goodsNum ;//= "3000057",
@property(nonatomic,assign) CGFloat prepayMoney ;//= 0,
@property(nonatomic,strong)NSString *subStatus ;//= <null>,
@property(nonatomic,strong)NSString *handleTime;// = <null>,
@property(nonatomic,strong)NSString *orderSubNum ;//= "20200812173544100115",
@property(nonatomic,strong)NSString *marketLevel ;//= <null>,
@property(nonatomic,assign) CGFloat rate;// = 0,

@end
