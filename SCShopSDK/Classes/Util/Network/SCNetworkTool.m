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

typedef NS_ENUM(NSInteger, SCEnvitonmentKey) {
    SCEnvitonmentKeyNone,
    SCEnvitonmentKeyTest,
    SCEnvitonmentKeyRelease
};

static NSString *kSCEnvironmentChangeKey = @"SCEnvironmentChangeKey1.1.5";

@interface SCNetworkTool ()
AS_SINGLETON(SCNetworkTool)
@property (nonatomic, assign) BOOL isRelease;
@end

@implementation SCNetworkTool
DEF_SINGLETON(SCNetworkTool)
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSInteger key = [[NSUserDefaults standardUserDefaults] integerForKey:kSCEnvironmentChangeKey];
        if (key == SCEnvitonmentKeyTest) {
            self.isRelease = NO;
            
        }else if (key == SCEnvitonmentKeyRelease) {
            self.isRelease = YES;
            
        }else { //首次加载，默认情况下的环境
            self.isRelease = YES;
        }
        
    }
    return self;
}

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
    SCReachability *y = [SCReachability reachabilityWithHostname:@"www.baidu.com"];
    NSUInteger netStatus = y.status;

    if (netStatus == SCReachabilityStatusWiFi) {
        return @"1";
        
    }else if(netStatus == SCReachabilityStatusWWAN){
        NSUInteger wwamStatus = y.wwanStatus;
        switch (wwamStatus) {
            case SCReachabilityWWANStatus2G:
                return @"2";//@"2G";
                break;
            case SCReachabilityWWANStatus3G:
                return @"3";//@"3G";
                break;
            case SCReachabilityWWANStatus4G:
                return @"4";//@"4G";
                break;
            default:
                return @"0";//@"WWAM";
                break;
        }
        
    }else{
        return @"0";
    }
}

//切换环境 临时测试用
+ (BOOL)isRelease
{
    BOOL isRelease = [self sharedInstance].isRelease;
    return isRelease;
}

+ (void)changeRelease
{
    BOOL newIsRelease = ![self isRelease];
    [[NSUserDefaults standardUserDefaults] setInteger:(newIsRelease?SCEnvitonmentKeyRelease:SCEnvitonmentKeyTest) forKey:kSCEnvironmentChangeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self sharedInstance].isRelease = newIsRelease;
    
    NSString *message = [NSString stringWithFormat:@"%@",newIsRelease?@"正式环境":@"测试环境"];
    [self showWithStatus:message];
}

@end
