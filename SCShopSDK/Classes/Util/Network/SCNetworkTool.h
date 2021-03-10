//
//  SCNetworkTool.h
//  shopping
//
//  Created by gejunyu on 2020/8/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCNetworkTool : NSObject

//数据正确性验证
+ (BOOL)checkCode:(id)responseObject failure:(nullable SCHttpRequestFailed)failure;
+ (BOOL)checkResult:(id)responseObject key:(nullable NSString *)key forClass:(Class)cls failure:(nullable SCHttpRequestFailed)failure;
+ (BOOL)checkCode:(id)responseObject completion:(nullable SCHttpRequestCompletion)completion;
+ (BOOL)checkResult:(id)responseObject key:(nullable NSString *)key forClass:(Class)cls completion:(nullable SCHttpRequestCompletion)completion;


//网络状态
+ (NSString *)networkType;


@end

NS_ASSUME_NONNULL_END
