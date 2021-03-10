//
//  SCUserInfo.h
//  shopping
//
//  Created by zhangtao on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCUserInfo : NSObject

typedef enum : NSUInteger {
    LoginTypeNone,
    LoginTypePassword,      // 服务密码登录
    LoginTypeSMS,           // 短信密码登录
    LoginTypeAvoid,         // 免登录
    LoginTypeOneKeyAvoid,   // 一键登录
    loginTpeVistor          //游客模式登录
} LoginType;

//! 手机号码
@property (nonatomic, copy) NSString *phoneNumber;
//! 服务密码
@property (nonatomic, copy) NSString *password;
//! 是否已登录
@property (nonatomic, assign) BOOL isLogin;
//! 登录类型
@property (nonatomic, assign) LoginType loginType;
//! 短信验证码是否验证
@property (nonatomic, assign) BOOL hasVerifiedBySMS;
//! 分销商标识
@property (nonatomic, copy) NSString *jxs;
@property (nonatomic, copy) NSString *bbn;
@property (nonatomic, copy) NSString *ubn;
@property (nonatomic, copy) NSString *sc;
@property (nonatomic, copy) NSString *us;
/**
 地市大编码    BOSS编码
 苏州市 11     镇江市 18
 淮安市 12     无锡市 19
 宿迁市 13     南通市 20
 南京市 14     泰州市 21
 连云港 15     盐城市 22
 徐州市 16     扬州市 23
 常州市 17
 */
@property (nonatomic, copy) NSString *uan;
//! 是否是4G用户
@property (nonatomic, assign) BOOL is4G;
//! 地市
@property (nonatomic, copy) NSString *cjn;
//! 品牌名
@property (nonatomic, copy) NSString *bjnn;
//! 品牌缩写
@property (nonatomic, copy) NSString *bjn;
@property (nonatomic, copy) NSString *upm;
@property (nonatomic, copy) NSString *uad;
//! 用户名
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cbn;
@property (nonatomic, copy) NSString *uc;
//! 视娱是否是二级页面跳转回来，1是
@property (nonatomic, copy) NSString *entertaionmentSkip;
//! 号码归属地
@property (nonatomic, copy) NSString *phoneAttribution;
//! 星级
@property (nonatomic, copy) NSString *star;
//! 品牌代码
@property (nonatomic, copy) NSString *brandBusiNum;
//! 2G流量，单位Kb
@property (nonatomic, copy) NSString *twoNetFlux;
//! 3G流量，单位Kb
@property (nonatomic, copy) NSString *threeNetFlux;
//! 4G流量，单位Kb
@property (nonatomic, copy) NSString *fourNetFlux;
//! 是否是20元封顶,0代表不是，1代表是
@property (nonatomic, copy) NSString *isUnlimitedBandwidth;
//! 是否是随意玩 0代表不是，1代表是
@property (nonatomic, copy) NSString *isPlayAt;
//!
// GPRS流量，仪表盘（首页和流量查询）下方展示信息根据：isHalfFlag状态位判断，替换原来使用isPlayAt判断，规则一样
@property (nonatomic, copy) NSString *isHalfFlag;
//! 20元封顶使用流量
@property (nonatomic, copy) NSString *useFlux;
//! 是否开通了专用流量
@property (nonatomic, assign) BOOL isUsedZy;
//! 专用流量总值
@property (nonatomic, copy) NSString *zyTotal;
//! 专用流量已使用值
@property (nonatomic, copy) NSString *zyUsed;
//! 专用流量剩余值
@property (nonatomic,copy) NSString *zyRemaing;
//! 是否开通了通用流量
@property (nonatomic, assign) BOOL isUsedTy;
//! 通用流量总值
@property (nonatomic, copy) NSString *tyTotal;
//! 通用流量已使用值
@property (nonatomic, copy) NSString *tyUsed;
//! 通用流量剩余值
@property(nonatomic,copy) NSString * tyRemaining;
//! E币
@property (nonatomic, copy) NSString *eCoin;
//! 神州行全球通积分
@property (nonatomic, copy) NSString *score;
//! 动感地带M值
@property (nonatomic, copy) NSString *mpoint;
//! 支付宝公钥
@property (nonatomic, copy) NSString *alixPayPubkey;
//! 网龄
@property (nonatomic,copy) NSString *useAge;
//! 超出流量
@property (nonatomic,copy) NSString *overFlux;
//! 本月已用
@property (nonatomic, copy) NSString *curMonthFlux;
//! 今日已用
@property (nonatomic, copy) NSString *curDayFlux;
//! 建议日均
@property (nonatomic, copy) NSString *advAvgDayFlux;
//! 提示语
@property (nonatomic, copy) NSString *notice;
//! 提示语
@property (nonatomic, copy) NSString *avgDayUsedFlux;
//! 提示语url
@property (nonatomic, copy) NSString *noticeUrl;
//! 余额不足弹窗
@property (nonatomic, copy) NSDictionary *balanceRemind;
//！营销案到期提醒
@property (nonatomic, copy) NSDictionary *flowRemind;
//！国际漫游流量超出提醒
@property (nonatomic, copy) NSDictionary *overInternationalFlow;

//! 流量专区--是否是20元封顶
@property (nonatomic, assign) BOOL is20FD;
//! 流量专区--是否开通通用
@property (nonatomic, assign) BOOL isUsedTyFlux;
//! 流量专区--是否开通专用
@property (nonatomic, assign) BOOL isUsedZyFlux;
//! 流量专区--通用总流量
@property (nonatomic, copy) NSString *tyTotalFlux;
//! 流量专区--通用剩余流量
@property (nonatomic, copy) NSString *tyLeftFlux;
//! 流量专区--通用已用流量
@property (nonatomic, copy) NSString *tyUserFlux;
//! 流量专区--专用剩余流量
@property (nonatomic, copy) NSString *zyLeftFlux;
//! 流量专区--专用已用流量
@property (nonatomic, copy) NSString *zyUserFlux;
//! 流量专区--专用总流量
@property (nonatomic, copy) NSString *zyTotalFlux;
//! 流量专区--超出流量
@property (nonatomic,copy) NSString *tyOverFlux;
//!大数据开关
@property (nonatomic,copy) NSString *bigDataSwitch;
//!全链路开关
@property (nonatomic,copy) NSString *wholeLinkSwitch;
//! 入网时间
@property (nonatomic, copy) NSString *registerTime;
//! 用户状态
@property (nonatomic, copy) NSString *userStatus;
//! 认证状态
@property (nonatomic, copy) NSString *verifyStatus;
//! 模糊名
@property (nonatomic, copy) NSString *unCleraName;
//! 和生活密钥
@property (nonatomic, copy) NSString *heLifeSecretKey;
//! 流量类型（0:限量 1:全国不限量 2:全省不限量 3:全市不限量）
@property (nonatomic, copy) NSString *isUnLimited;
//! 不限量名称
@property (nonatomic, copy) NSString *typeName;
//! 流量阀值
@property (nonatomic, copy) NSString *thresHold;
//! 是否超过流量阀值
@property (nonatomic, assign) BOOL isOutThresHold;
//! 是否超过流量最大量
@property (nonatomic, assign) BOOL isOutmax;
//! 超过流量最大量提示信息
@property (nonatomic, copy) NSString *outMaxMsg;
//! 限速提醒
@property (nonatomic, copy) NSString *limitMessage;
//! 提速标题
@property (nonatomic, copy) NSString *speedName;
//! 提速url
@property (nonatomic, copy) NSString *speedUrl;
//! 超出阀值表盘标题
@property (nonatomic, copy) NSString *promptName;
//! 尊享用户
@property (nonatomic, assign) BOOL isAdjectiveUser;
//! 副卡
@property (nonatomic, strong) NSDictionary *familyDic;
//! 副卡展开收起图标
@property (nonatomic, copy) NSString *familyImgUrl;
//! 和生活够买记录使用
@property (nonatomic, copy) NSString *androidCookie;
//! 订阅开关
@property (nonatomic, copy) NSString *openStr;
//! 等级
@property (nonatomic, copy) NSString *startLevel;
//!萌小鹿分享白名单开关
@property (nonatomic,assign) BOOL mxlShareSwitch;
//!萌小鹿展示白名单开关
@property (nonatomic,assign) BOOL mxlShowSwitch;
//！键盘语音搜索开关
@property (nonatomic, assign) BOOL jpShowSwitch;
//!萌小鹿域名
@property (nonatomic, strong) NSString *mxlUrl;
//!公网ip
@property (nonatomic, strong) NSString * selfPublicIp;
//!当前用户是否为白名单号码
@property (nonatomic, strong) NSString *h5WhiteUser;
//!表盘左侧营销位
@property (nonatomic, strong) NSDictionary *leftDialAdDic;
//!表盘右侧营销位
@property (nonatomic, strong) NSDictionary *rightDialAdDic;
//! 余额
@property (nonatomic, copy) NSString *balance;
//! 当月消费
@property (nonatomic, copy) NSString *curMonthFee;
//!积分
@property (nonatomic, copy) NSString *integral;
//!表盘背景
@property (nonatomic, copy) NSString *dashboardBackImgUrl;
//! 首页表盘查账单
@property (nonatomic, strong) NSDictionary *queryBillDic;
//！首页表盘充话费
@property (nonatomic, strong) NSDictionary *payBillDic;
//！首页表盘玩积分
@property (nonatomic, strong) NSDictionary *playIntegralDic;
//! 导航状态,1异网请求，2本网请求
@property (nonatomic, copy) NSString *tabbarType;
//! 个人资料-5G速率
@property (nonatomic, copy) NSString *column5G;
/*
 *语音表盘
 */
//！首页语音表盘开关
@property (nonatomic, copy) NSString *voiceDialOpen;
//！首页语音表盘标题
@property (nonatomic, copy) NSString *voiceDialTitle;
//！首页语音表盘语音值
@property (nonatomic, copy) NSString *voiceDialValue;
//！首页语音表盘语音已用值
@property (nonatomic, copy) NSString *voiceDialUsedValue;
//！首页语音表盘语音总共值
@property (nonatomic, copy) NSString *voiceDialTotalValue;
//！首页语音表盘提示
@property (nonatomic, copy) NSString *voiceDialTip;
//！首页语音表盘详情
@property (nonatomic, copy) NSString *voiceDialState;
/*
 *通用表盘
 */
//！首页通用表盘开关
@property (nonatomic, copy) NSString *commonDialOpen;
//！首页通用表盘标题
@property (nonatomic, copy) NSString *commonDialTitle;
//！首页通用表盘流量
@property (nonatomic, copy) NSString *commonDialValue;
//！首页通用表盘流量已用
@property (nonatomic, copy) NSString *commonDialUsedValue;
//！首页通用表盘流量总共
@property (nonatomic, copy) NSString *commonDialTotalValue;
//！首页通用表盘提
@property (nonatomic, copy) NSString *commonDialTip;
//！首页通用表盘百分
@property (nonatomic, copy) NSString *commonDialPercentage;

/*
 *专用表盘
 */
//！首页专用表盘开关
@property (nonatomic, copy) NSString *specialDialOpen;
//！首页专用表盘标题
@property (nonatomic, copy) NSString *specialDialTitle;
//！首页专用表盘流量值
@property (nonatomic, copy) NSString *specialDialValue;
//！首页专用表盘流量已用值
@property (nonatomic, copy) NSString *specialDialUsedValue;
//！首页专用表盘流量总共值
@property (nonatomic, copy) NSString *specialDialTotalValue;
//！首页专用表盘提示
@property (nonatomic, copy) NSString *specialDialTip;
//！是否本网登录
@property (nonatomic, assign) BOOL isJSMobile;
//!是否是微信登陆
@property (nonatomic, assign) BOOL isWXLogin;
//!本机本卡号码状态 用户状态:19表示待激活,1表示正使用,3表示欠费半停,2表示欠费全停,8表示销户,20表示回收
@property (nonatomic, copy) NSString* localState;
//!本机本卡号码
@property (nonatomic, copy) NSString * localPhone;
//!是否已显示绿充
@property (nonatomic, assign) BOOL isGreenTop;
//! 预加载开关
@property (nonatomic, strong) NSDictionary *prestrainSwitchDic;
//好友列表
@property (nonatomic, strong) NSArray *shareFriendsArr;


//增加属性，掌厅userInfo中没有，需要转换成字典后单独添加
@property(nonatomic,strong)NSString *cmtokenid;

+ (instancetype)currentUser;

//- (void)clear;
@end

