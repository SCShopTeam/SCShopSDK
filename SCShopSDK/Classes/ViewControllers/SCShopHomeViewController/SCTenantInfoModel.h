//
//  SCTenantInfoModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCTenantInfoModel : NSObject
@property (nonatomic, copy) NSString *createTime;     //"2018-07-31 00:00:00"
@property (nonatomic, copy) NSString *shopLatitude;    //"1234"
@property (nonatomic, copy) NSString *shopLongitude;
@property (nonatomic, copy) NSString *shopName;       //"店铺aaa"
@property (nonatomic, copy) NSString *status;         //1
@property (nonatomic, copy) NSString *statusName;     //启用
@property (nonatomic, copy) NSString *tenantAddress;  //"南京南昌路40号长江科技园2楼"
@property (nonatomic, copy) NSString *tenantEmail;
@property (nonatomic, copy) NSString *tenantLinkman;  //租户
@property (nonatomic, copy) NSString *tenantMobile;   //"13225623426"
@property (nonatomic, copy) NSString *tenantName;     //"默认租户/企业"
@property (nonatomic, copy) NSString *tenantNum;      //"1000000"
@property (nonatomic, copy) NSString *tenantPhone;    //"1000000"
@property (nonatomic, copy) NSString *tenantType;     //1 自营 2 他营
@property (nonatomic, copy) NSString *voildTimeBegin;  //"2018-07-07"
@property (nonatomic, copy) NSString *voildTimeEnd;    //"2018-08-31"
@property (nonatomic, copy) NSString *tenantIcon;      //


@property (nonatomic, copy) NSString *ctiyNum;
@property (nonatomic, copy) NSString *tenantTypeNum;
@property (nonatomic, copy) NSString *operTime;
@property (nonatomic, copy) NSString *card;
@property (nonatomic, copy) NSString *bankAccount;
@property (nonatomic, copy) NSString *loginMobile;
@property (nonatomic, copy) NSString *lawman;
@property (nonatomic, copy) NSString *inviteManname;
@property (nonatomic, copy) NSString *busiLicNo;
@property (nonatomic, copy) NSString *busiLicPic;
@property (nonatomic, copy) NSString *operManname;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *orgNum;
@property (nonatomic, copy) NSString *inviteMancode;
@property (nonatomic, copy) NSString *tenantMemo;
@property (nonatomic, copy) NSString *areaNum;
@property (nonatomic, copy) NSString *lawmanCard;
@property (nonatomic, copy) NSString *operMemo;
@property (nonatomic, copy) NSString *angentNumber;
@property (nonatomic, copy) NSString *verNum;
@property (nonatomic, copy) NSString *smsSign;
@property (nonatomic, copy) NSString *channelCode;
@property (nonatomic, copy) NSString *operMancode;

@end

NS_ASSUME_NONNULL_END
