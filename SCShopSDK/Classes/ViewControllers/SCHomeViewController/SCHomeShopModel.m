//
//  SCHomeShopModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/19.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomeShopModel.h"

@implementation SCHomeShopModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"shopInfo": SCHShopInfoModel.class,
             @"bannerList": SCHBannerModel.class,
             @"actList": SCHActModel.class};
}

@end

@implementation SCHShopInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"defaultStr" : @"default"};
}


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.isFindGood = [self.position isEqualToString:@"2"];
    
    return YES;
}

@end

@implementation SCHBannerModel

@end

@implementation SCHActModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"actImageList": SCHActImageModel.class};
}

@end

@implementation SCHActImageModel

@end

