//
//  SCNetworkTool.h
//  shopping
//
//  Created by gejunyu on 2020/8/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCEnvitonmentKey) {
    SCEnvitonmentKeyNone,      //未知
    SCEnvitonmentKeyTest,      //测试环境
    SCEnvitonmentKeyRelease    //正式环境
};

//是否可以切换环境   测试时为yes  上线关闭
static BOOL SC_CAN_CHANGE_ENVIRONMENT = NO;
//默认正式环境
static SCEnvitonmentKey kDefaultEnvironmentKey = SCEnvitonmentKeyRelease;


NS_ASSUME_NONNULL_BEGIN

@interface SCNetworkTool : NSObject

//数据正确性验证
+ (BOOL)checkCode:(id)responseObject failure:(nullable SCHttpRequestFailed)failure;
+ (BOOL)checkResult:(id)responseObject key:(nullable NSString *)key forClass:(Class)cls failure:(nullable SCHttpRequestFailed)failure;
+ (BOOL)checkCode:(id)responseObject completion:(nullable SCHttpRequestCompletion)completion;
+ (BOOL)checkResult:(id)responseObject key:(nullable NSString *)key forClass:(Class)cls completion:(nullable SCHttpRequestCompletion)completion;


//网络状态
+ (NSString *)networkType;


//切换环境 临时测试用
+ (BOOL)isRelease;
+ (void)changeRelease;


@end

NS_ASSUME_NONNULL_END
