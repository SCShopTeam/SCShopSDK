//
//  SCCommodityModel.m
//  shopping
//
//  Created by zhangtao on 2020/8/6.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCommodityModel.h"

@implementation SCCommodityModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if ([self.tenantType isEqualToString:@"1"]) {
        self.tenantTypeStr = @"自营";
        
    }else if ([self.tenantType isEqualToString:@"3"]) {
        self.tenantTypeStr = @"门店";
    }
    
    return YES;
}

+ (NSArray <SCCommodityModel *> *)getModelsFrom:(NSArray *)datas
{
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:datas.count];
    
    for (NSDictionary *dict in datas) {
        if (VALID_DICTIONARY(dict)) {
            SCCommodityModel *model = [SCCommodityModel yy_modelWithDictionary:dict];
            [mulArr addObject:model];
            
        }
    }
    
    return mulArr.copy;
}


@end
