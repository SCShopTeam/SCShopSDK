//
//  SCGetAuthToken.m
//  shopping
//
//  Created by zhangtao on 2020/9/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCGetAuthToken.h"

@implementation SCGetAuthToken


+ (NSString*)getUnifyAuthToken :(NSString*)name
{
    NSString* authToken = @"";
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        //        NSLog(@"%@: %@", cookie.name, cookie.value);
        if([SCUtilities isValidString:cookie.name]
           && [cookie.name isEqualToString:name])
        {
            authToken = [SCUtilities isValidString:cookie.value]? cookie.value : @"";
            break;
        }
    }
    
    return authToken;
}

+(NSString *)cmtokenId{
    
    return [SCGetAuthToken getUnifyAuthToken:@"cmtokenid"];
    
//    NSString *s = [SCUserInfo currentUser].cmtokenid;
//    if ([SCUtilities isValidString:s]) {
//        return s;
//    }
//    return @"";
}

+(NSString *)mallPhone{
    NSString *s = [SCUserInfo currentUser].phoneNumber;
    if ([SCUtilities isValidString:s]) {
        return s;
    }
    return @"";
}

+(NSString *)userAreaNum{
    
    return [SCGetAuthToken getUnifyAuthToken:@"userAreaNum"];
    
//    NSString *s = [SCUserInfo currentUser].uan;
//    if ([SCUtilities isValidString:s]) {
//        return s;
//    }
//    return @"";
}

@end
