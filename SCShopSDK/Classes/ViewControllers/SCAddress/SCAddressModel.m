//
//  SCAddressModel.m
//  shopping
//
//  Created by gejunyu on 2020/7/31.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCAddressModel.h"

@implementation SCAddressModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    id isDefault = dic[@"default"];
    NSString *isDefaultStr = NSStringFormat(@"%@",isDefault);
    self.isDefault = [isDefaultStr isEqualToString:@"1"];
    
    return YES;
}

- (void)copyData:(SCAddressModel *)otherModel
{
    self.provinceNum  = otherModel.provinceNum;
    self.provinceName = otherModel.provinceName;
    self.cityNum      = otherModel.cityNum;
    self.cityName     = otherModel.cityName;
    self.regionNum    = otherModel.regionNum;
    self.regionName   = otherModel.regionName;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
