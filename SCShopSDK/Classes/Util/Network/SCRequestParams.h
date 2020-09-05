//
//  SCRequestParams.h
//  shopping
//
//  Created by zhangtao on 2020/7/29.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCRequestParams : NSObject

@property(nonatomic,strong)NSString *userOs;
@property(nonatomic,strong)NSString *userNetwork;
@property(nonatomic,strong)NSString *userAppVer;

@property (nonatomic, strong) NSString *appPwd;//应用密钥

@property (nonatomic, strong) NSString *appid;//应用id
@property(nonatomic,strong)NSString*requestNum;  //接口编码
@property(nonatomic,strong)NSString *sessionId;

@property(nonatomic,strong)NSString *userRegion;  //用户手机号归属市   //登录后返回的

+(instancetype)shareInstance;

-(NSMutableDictionary *)getParams;

-(void)clearParams;


@end

NS_ASSUME_NONNULL_END
