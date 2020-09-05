//
//  SCGetAuthToken.m
//  shopping
//
//  Created by zhangtao on 2020/9/4.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCGetAuthToken.h"

@implementation SCGetAuthToken

+(NSString *)cmtokenId{
    NSString *s = [SCUserInfo currentUser].cmtokenid;
    if ([SCUtilities isValidString:s]) {
        return s;
    }
    return @"";
}

+(NSString *)mallPhone{
    NSString *s = [SCUserInfo currentUser].phoneNumber;
    if ([SCUtilities isValidString:s]) {
        return s;
    }
    return @"";
}

+(NSString *)userAreaNum{
    NSString *s = [SCUserInfo currentUser].uan;
    if ([SCUtilities isValidString:s]) {
        return s;
    }
    return @"";
}

@end
