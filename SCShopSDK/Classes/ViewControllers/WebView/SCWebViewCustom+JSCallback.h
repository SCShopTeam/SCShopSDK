//
//  SCWebViewCustom+JSCallback.h
//  ecmc
//
//  Created by gaoleyu on 16/11/28.
//  Copyright © 2016年 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCWebViewCustom.h"

enum E_Scheme
{
    SC_Speedtest,
    SC_Ecmcshare,        //是否显示分享
    SC_Ecmcwebshare,     //是否显示分享
    SC_WXMini,//拉起微信小程序
};

//const NSArray *__urlSchemeType;
// 创建初始化函数，等于用宏创建一个getter函数
//#define urlSchemeFramewrokTypeGet (__urlSchemeType == nil ? __urlSchemeType = [[NSArray alloc] initWithObjects:\
//@"speedtest",\
//@"ecmcshare",\
//@"ecmcwebshare",\
//@"activityremind",\
//@"ecmcapp",\
//@"showshare",\
//@"displayshareonright",\
//@"mapnavigation",\
//@"startAppPage",\
//@"palmshop",\
//@"safari",\
//@"phonestore",\
//@"ecmc",\
//@"nonmobilelogout",\
//@"nonmobilewebpush",\
//@"wechatshare",\
//@"closewebview",\
//@"hiddenclose",\
//@"showclose",\
//@"hiddennavibar",\
//@"iportalapp",\
//@"shownavibar",\
//@"networkcontact",\
//@"jsmcc",\
//@"scanimageshare",\
//@"newzzdfriendshare",\
//@"scanwebcback",\
//@"launchwxminiprogram",\
//@"launchwxbinding",\
//@"feedback",\
//@"returnfeedback",\
//@"viewcontrollertitle",\
//@"hePackJudge",\
//@"ecmclivechat",\
//nil]:__urlSchemeType)
//
//// 枚举 to 字串
//#define urlSchemeTypeToString(type) ([urlSchemeFramewrokTypeGet objectAtIndex:type])
//// 字串 to 枚举
//#define urlSchemeTypeToEnum(string) ([urlSchemeFramewrokTypeGet indexOfObject:string])

@interface SCWebViewCustom(JSCallback)<UIActionSheetDelegate>

- (BOOL)parseScheme : (NSURLRequest *)request;

#pragma mark--加载js回调方法
- (void)jsCallBackOCFunction;

#pragma mark --oc回调JS方法
-(void)ocCallBackJsFunction:(NSNotification *)notify;
@end
