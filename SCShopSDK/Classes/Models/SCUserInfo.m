//
//  SCUserInfo.m
//  shopping
//
//  Created by zhangtao on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCUserInfo.h"
#import "SCShoppingManager.h"

@implementation SCUserInfo

+ (instancetype)currentUser
{
    SCUserInfo *userInfo;
    
    if ([[SCShoppingManager sharedInstance].delegate respondsToSelector:@selector(scGetUserInfo)]) {
        
        NSDictionary *dict = [[SCShoppingManager sharedInstance].delegate scGetUserInfo];
        
        userInfo = [SCUserInfo yy_modelWithDictionary:dict];

    }
    
    return userInfo ?: [SCUserInfo new];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.isJSMobile = [dic[@"isJSMobile"] integerValue];
    self.isLogin    = [dic[@"isLogin"] integerValue];
    
    return YES;
}

- (NSString *)brandBusiNum
{
    if ([_bjn isEqualToString:@"QQT"]) {
        return @"1";
    } else if ([_bjn isEqualToString:@"DGDD"]) {
        return @"2";
    } else if ([_bjn isEqualToString:@"SZX"]) {
        return @"3";
    }
    return nil;
}

- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    if (!isLogin) {
        _loginType = LoginTypeNone;
    }
}

//- (void)clear
//{
//    self.isJSMobile = NO;
//    self.phoneNumber = nil;
//    self.password = nil;
//    self.isLogin = NO;
//    self.loginType = LoginTypeNone;
//    self.hasVerifiedBySMS = NO;
//    self.jxs = nil;
//    self.bbn = nil;
//    self.ubn = nil;
//    self.sc = nil;
//    self.us = nil;
//    self.phoneAttribution = nil;
//    self.uan = nil;
//    self.is4G = NO;
//    self.cjn = nil;
//    self.bjnn = nil;
//    self.upm = nil;
//    self.uad = nil;
//    self.name = nil;
//    self.bjn = nil;
//    self.cbn = nil;
//    self.uc = nil;
//    self.brandBusiNum = nil;
//    self.balance = nil;
//    self.curMonthFee = nil;
//    self.twoNetFlux = nil;
//    self.threeNetFlux = nil;
//    self.fourNetFlux = nil;
//    self.isUnlimitedBandwidth = nil;
//    self.isPlayAt = nil;
//    self.isHalfFlag = nil;
//    self.useFlux = nil;
//    self.isUsedZy = NO;
//    self.zyTotal = nil;
//    self.zyUsed = nil;
//    self.isUsedTy = NO;
//    self.tyTotal = nil;
//    self.tyUsed = nil;
//    self.eCoin = nil;
//    self.score = nil;
//    self.mpoint = nil;
//    self.alixPayPubkey = nil;
//    self.useAge = nil;
//    self.tyRemaining =nil;
//    self.zyRemaing =nil;
//    self.isUsedTyFlux = NO;
//    self.isUsedZyFlux = NO;
//    self.tyLeftFlux = nil;
//    self.tyUserFlux = nil;
//    self.tyTotalFlux = nil;
//    self.zyLeftFlux = nil;
//    self.zyUserFlux = nil;
//    self.zyTotalFlux = nil;
//    self.is20FD = NO;
//    self.tyOverFlux = nil;
//    self.overFlux = nil;
//    self.curDayFlux = nil;
//    self.curMonthFee = nil;
//    self.curMonthFlux = nil;
//    self.notice = nil;
//    self.noticeUrl = nil;
//    self.balanceRemind = nil;
//    self.registerTime = nil;
//    self.userStatus = nil;
//    self.verifyStatus = nil;
//    self.unCleraName = nil;
//    self.star = nil;
//    self.heLifeSecretKey = nil;
//    self.isUnLimited = nil;
//    self.typeName = nil;
//    self.thresHold = nil;
//    self.limitMessage = nil;
//    self.speedName = nil;
//    self.speedUrl = nil;
//    self.promptName = nil;
//    self.isOutThresHold = NO;
//    self.isOutmax = NO;
//    self.outMaxMsg = nil;
//    self.isAdjectiveUser = YES;
//    self.familyDic = nil;
//    self.familyImgUrl = nil;
//    self.androidCookie = nil;
//    self.openStr = nil;
//    self.startLevel = nil;
//    self.mxlShowSwitch = NO;
//    self.mxlShareSwitch = NO;
//    self.jpShowSwitch = NO;
//    self.mxlUrl = nil;
//    self.selfPublicIp = nil;
//    self.h5WhiteUser = nil;
//    self.tabbarType = nil;
//
//    self.integral = nil;
//    self.queryBillDic = nil;
//    self.payBillDic = nil;
//    self.playIntegralDic = nil;
//    self.leftDialAdDic = nil;
//    self.rightDialAdDic = nil;
//
//    self.voiceDialOpen = nil;
//    self.voiceDialTitle = nil;
//    self.voiceDialValue = nil;
//    self.voiceDialUsedValue = nil;
//    self.voiceDialTotalValue = nil;
//    self.voiceDialTip = nil;
//    self.voiceDialState = nil;
//
//    self.commonDialOpen = nil;
//    self.commonDialTitle = nil;
//    self.commonDialValue = nil;
//    self.commonDialUsedValue = nil;
//    self.commonDialTotalValue = nil;
//    self.commonDialTip = nil;
//    self.commonDialPercentage = nil;
//
//    self.specialDialOpen = nil;
//    self.specialDialTitle = nil;
//    self.specialDialValue = nil;
//    self.specialDialUsedValue = nil;
//    self.specialDialTotalValue = nil;
//    self.specialDialTip = nil;
//    self.tabbarType = nil;
//    self.column5G = nil;
//
//    self.isWXLogin = NO;
////    self.entertaionmentSkip = nil;
//    self.localState = nil;
//    self.localPhone = nil;
//    self.isGreenTop = NO;
//    self.dashboardBackImgUrl = nil;
//    self.shareFriendsArr = nil;
//
//    self.cmtokenid = nil;
//}

@end

