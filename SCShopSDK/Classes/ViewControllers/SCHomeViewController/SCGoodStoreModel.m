//
//  SCGoodStoreModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/19.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCGoodStoreModel.h"

@implementation SCGoodStoreModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"shopInfo": SCGShopInfoModel.class,
             @"bannerList": SCGBannerModel.class,
             @"actList": SCGActModel.class};
}

@end

@implementation SCGShopInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"defaultStr" : @"default"};
}


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.isFindGood = [self.position isEqualToString:@"2"];
    
    return YES;
}

@end

@implementation SCGBannerModel

@end

@implementation SCGActModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"actImageList": SCGActImageModel.class};
}

@end

@implementation SCGActImageModel

@end

