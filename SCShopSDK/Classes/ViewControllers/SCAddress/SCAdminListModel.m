//
//  SCAdminListModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCAdminListModel.h"

@implementation SCAdminListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"children": SCAdminListModel.class};
}

//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
//{
//    id isDefault = dic[@"default"];
//    NSString *isDefaultStr = NSStringFormat(@"%@",isDefault);
//    self.isDefault = [isDefaultStr isEqualToString:@"1"];
//    return YES;
//}

@end
