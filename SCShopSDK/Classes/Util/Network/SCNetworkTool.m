//
//  SCNetworkTool.m
//  shopping
//
//  Created by gejunyu on 2020/8/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCNetworkTool.h"
#import "SCReachability.h"

typedef NS_ENUM(NSInteger, SCNetApiType) {
    SCNetApiTypeB2C,
    SCNetApiTypeS,
    SCNetApiTypeApollo
};

@implementation SCNetworkTool

//数据验证
+ (BOOL)checkCode:(id)responseObject failure:(nullable SCHttpRequestFailed)failure completion:(SCHttpRequestCompletion)completion
{
    if (!VALID_DICTIONARY(responseObject)) {
        [self callBack:@"解析错误" failure:failure completion:completion];

        return NO;
    }
    
    NSString *codeKey;
    NSString *successCode;
    NSString *messageKey;
    
    SCNetApiType apiType = [self getApiType:responseObject];
    
    switch (apiType) {
        case SCNetApiTypeB2C:
        {
            codeKey     = B_CODE;
            successCode = B_SUCCESS_CODE;
            messageKey  = B_MESSAGE;
        }
            break;
        case SCNetApiTypeS:
        {
            codeKey     = S_CODE;
            successCode = S_SUCCESS_CODE;
            messageKey  = S_MESSAGE;
        }
            break;
        case SCNetApiTypeApollo:
        {
            codeKey     = A_CODE;
            successCode = A_SUCCESS_CODE;
            messageKey  = A_MESSAGE;
        }
            break;
            
        default:
            break;
    }
    
    NSString *code = NSStringFormat(@"%@", responseObject[codeKey])  ;
    if (![code isEqualToString:successCode]) {
        NSString *message = responseObject[messageKey];
        [self callBack:message failure:failure completion:completion];
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkResult:(id)responseObject key:(nullable NSString *)key forClass:(Class)cls failure:(nullable SCHttpRequestFailed)failure completion:(SCHttpRequestCompletion)completion
{
    if (![self checkCode:responseObject failure:failure completion:completion]) {
        return NO;
    }
    
    NSString *errorMsg;
    
    SCNetApiType apiType = [self getApiType:responseObject];
    
    NSString *resultKey;
    
    switch (apiType) {
        case SCNetApiTypeB2C:
            resultKey = B_RESULT;
            break;
        case SCNetApiTypeS:
            resultKey = S_DATA;
            break;
        case SCNetApiTypeApollo:
            resultKey = A_RESULT;
            break;
            
        default:
            break;
    }
    
    id result = [(NSDictionary *)responseObject objectForKey:resultKey];
    
    if (VALID_STRING(key)) {
        if (!VALID_DICTIONARY(result)) {
            errorMsg = @"解析错误";
            
        }else {
            id value = ((NSDictionary *)result)[key];
            if (![value isKindOfClass:cls]) {
                errorMsg = @"解析错误";
            }
        }
        
    }else {
        if (![result isKindOfClass:cls]) {
            errorMsg = @"解析错误";
        }
    }

    if (errorMsg) {
        [self callBack:errorMsg failure:failure completion:completion];

        return NO;
        
    }else {
        return YES;
    }
}

+ (BOOL)checkCode:(id)responseObject failure:(nullable SCHttpRequestFailed)failure
{
   return [self checkCode:responseObject failure:failure completion:nil];
}

+ (BOOL)checkResult:(id)responseObject key:(nullable NSString *)key forClass:(Class)cls failure:(nullable SCHttpRequestFailed)failure
{
    return [self checkResult:responseObject key:key forClass:cls failure:failure completion:nil];
}

+ (BOOL)checkCode:(id)responseObject completion:(nullable SCHttpRequestCompletion)completion
{
    return [self checkCode:responseObject failure:nil completion:completion];
}

+ (BOOL)checkResult:(id)responseObject key:(nullable NSString *)key forClass:(Class)cls completion:(nullable SCHttpRequestCompletion)completion
{
    return [self checkResult:responseObject key:key forClass:cls failure:nil completion:completion];
}

+ (void)callBack:(NSString *)msg failure:(nullable SCHttpRequestFailed)failure completion:(SCHttpRequestCompletion)completion
{
    if (failure) {
        failure(msg);
        
    }else if (completion) {
        completion(msg);
        
    }
}

+ (SCNetApiType)getApiType:(NSDictionary *)dict
{
    NSArray *keys = [dict allKeys];
    SCNetApiType type;
    
    if ([keys containsObject:B_CODE]) {
        type = SCNetApiTypeB2C;
        
    }else if ([keys containsObject:S_CODE]) {
        type = SCNetApiTypeS;
        
    }else {
        type = SCNetApiTypeApollo;
    }
    
    return type;
}

//网络状态
+ (NSString *)networkType
{
    SCReachability *reachability = [SCReachability reachabilityWithHostname:@"www.baidu.com"];
    SCNetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    NSString *type = @"0";

    if (internetStatus == SCReachableViaWiFi) { //wifi
        type = @"1";

    }else if (internetStatus == SCReachableViaWWAN) { //流量
        SCWWANType wwanType = [reachability currentWWANType];
        
        switch (wwanType) {
            case SCWWANType2G:
                type = @"2";
                break;
            case SCWWANType3G:
                type = @"3";
                break;
            case SCWWANType4G:
                type = @"4";
                break;
            case SCWWANType5G:
                type = @"5";
                break;
                
            default:
                break;
        }
        
    }
    
    return type;

}

@end
