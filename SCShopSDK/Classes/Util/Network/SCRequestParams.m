//
//  SCRequestParams.m
//  shopping
//
//  Created by zhangtao on 2020/7/29.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCRequestParams.h"
#import "SCShoppingManager.h"
@implementation SCRequestParams

static SCRequestParams *params = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        params = [[SCRequestParams alloc]init];
    });
    return params;
}

/**
 获取cookie中统一认证token
 */
//- (NSString*)getUnifyAuthToken
//{
//    return [SCUtilities getUnifyAuthToken:@"cmtokenid"];
//}

-(NSString *)sessionId{
    
    _sessionId = [SCGetAuthToken cmtokenId];
    return _sessionId;
}

-(NSString *)userOs{
    if (!_userOs) {
        _userOs = @"iOS";
    }
    return _userOs;
}

-(NSString *)appid{
    if (!_appid) {
        _appid = @"mall";
    }
    return _appid;
}

-(NSString *)userNetwork{
      
    _userNetwork = [SCNetworkTool networkType];
    
    return _userNetwork;
}

-(NSString *)userAppVer{
    if (!_userAppVer) {
        _userAppVer = @"8.0.0";
    }
    return _userAppVer;
}

-(NSString *)appPwd{
    NSString *str = [NSString stringWithFormat:@"%@%@%@",self.sessionId,self.requestNum,self.appid];
    _appPwd = [str md5Value];
    
   
    
    return _appPwd;
}

-(NSMutableDictionary *)getParams{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([SCUtilities isValidString:self.userOs]) {
        dic[@"userOs"] = self.userOs;
    }
    
    if ([SCUtilities isValidString:self.userNetwork]) {
        dic[@"userNetwork"] = self.userNetwork;
    }
    
    if ([SCUtilities isValidString:self.userAppVer]) {
        dic[@"userAppVer"] = self.userAppVer;
       }
    
    if ([SCUtilities isValidString:self.appPwd]) {
        dic[@"appPwd"] = self.appPwd;
    }
    if ([SCUtilities isValidString:self.sessionId]) {
         dic[@"sessionId"] = self.sessionId;
    }
   //@"79BDF3AC82684796B21053D570CC1C68@js.ac.10086.cn";
    
    return dic;
}

-(void)clearParams{
    _userOs = nil;
    _userNetwork = nil;
    _userAppVer = nil;
    _appPwd = nil;
    _appid = nil;
    _requestNum = nil;
    _sessionId = nil;
}

@end
