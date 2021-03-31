//
//  SCHomeTouchModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/19.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCPopupType) {
    SCPopupTypeSide,     //侧边栏弹窗
    SCPopupTypeBottom,   //底部弹窗
    SCPopupTypeCenter    //中心弹窗
};

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeTouchModel : NSObject
@property (nonatomic, copy) NSString *pic2Url;
@property (nonatomic, copy) NSString *insertCode;
@property (nonatomic, copy) NSString *exposureUrl;
@property (nonatomic, copy) NSString *hotType;
@property (nonatomic, copy) NSString *interfaceURL;
@property (nonatomic, copy) NSString *contentNum;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *isView;
@property (nonatomic, copy) NSString *clickExpUrl;
@property (nonatomic, copy) NSString *isLogin;
@property (nonatomic, copy) NSString *sortNum;
@property (nonatomic, copy) NSString *targetUser;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, copy) NSString *txt;
@property (nonatomic, copy) NSString *hotTypeValue;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *cpmMax;
@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic, copy) NSString *advClickUrl;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *titleColor;
@property (nonatomic, copy) NSString *adType;
@property (nonatomic, copy) NSString *daCompid;
@property (nonatomic, copy) NSString *isMarkValue;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *advExposureUrl;
@property (nonatomic, copy) NSString *projectLevel1;
@property (nonatomic, copy) NSString *showType;
@property (nonatomic, copy) NSString *advExposureBodyFormat;
@property (nonatomic, copy) NSString *cpmContentMax;
@property (nonatomic, copy) NSString *isMark;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *adSource;
@property (nonatomic, copy) NSString *contentName;
@property (nonatomic, copy) NSString *interSource;
@property (nonatomic, copy) NSString *isVip;
@property (nonatomic, copy) NSString *txt2;
@property (nonatomic, copy) NSString *isSpecScene;
@property (nonatomic, copy) NSString *advExposureBody;
@property (nonatomic, copy) NSString *virtualClickNum;
@property (nonatomic, copy) NSString *mcTxt;
@property (nonatomic, copy) NSString *roundRefreshTime;
@property (nonatomic, copy) NSString *contentItNum;
@property (nonatomic, copy) NSString *frameNum;
@property (nonatomic, copy) NSString *advClickBody;
@property (nonatomic, copy) NSString *mcPicUrl;
@property (nonatomic, copy) NSString *condMainId;
@property (nonatomic, copy) NSString *projectLevel2;
@property (nonatomic, copy) NSString *isUseCdServer;
@property (nonatomic, copy) NSString *advClickBodyFormat;
@property (nonatomic, copy) NSString *isMc;

//自定义
//父类属性
@property (nonatomic, strong) NSDictionary *extraParam;
//下标   部分宫格数据可能返回为空，导致被过滤掉，导致大数据插码错误。例如第二宫格数据为空，首页显示的第二宫格其实是第三宫格，点击时插码时会用的是第二宫格的下标01
@property (nonatomic, assign) NSInteger codeIndex;
//弹窗
@property (nonatomic, assign) SCPopupType popupType;


+ (nullable NSMutableArray <SCHomeTouchModel *> *)createModelsWithDict:(NSDictionary *)dict;

- (NSDictionary *)getParams;

@end

NS_ASSUME_NONNULL_END
