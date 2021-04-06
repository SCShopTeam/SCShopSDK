//
//  SCCategoryModel.m
//  shopping
//
//  Created by zhangtao on 2020/8/6.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCategoryModel.h"
@implementation SCCategoryModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"secondList": SecondCategoryModel.class};
}

+ (NSArray<SCCategoryModel *> *)parsingModelsFromData:(NSArray *)data
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:data.count];
    
    for (NSDictionary *dict in data) {
        if (VALID_DICTIONARY(dict)) {
            SCCategoryModel *model = [SCCategoryModel yy_modelWithDictionary:dict];
            [temp addObject:model];
        }
        
    }
    
    return temp.copy;
}

@end


@implementation SecondCategoryModel



@end
