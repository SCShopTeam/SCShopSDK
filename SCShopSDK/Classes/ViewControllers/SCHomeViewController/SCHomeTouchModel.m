//
//  SCHomeTouchModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/19.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCHomeTouchModel.h"

@implementation SCHomeTouchModel

+ (NSMutableArray<SCHomeTouchModel *> *)createModelsWithDict:(NSDictionary *)dict
{
    if (!VALID_DICTIONARY(dict)) {
        return nil;
    }
    
    NSArray *content = dict[@"content"];
    
    if (!VALID_ARRAY(content)) {
        return nil;
    }
    
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:content.count];
    
    NSMutableDictionary *mulDict = dict.mutableCopy;
    [mulDict removeObjectForKey:@"content"];
    
    for (NSDictionary *dict in content) {
        if (VALID_DICTIONARY(dict)) {
            SCHomeTouchModel *model = [SCHomeTouchModel yy_modelWithDictionary:dict];
            model.extraParam = mulDict;
            
            [mulArr addObject:model];
        }
    }
    
    return mulArr;
    
}

- (NSDictionary *)getParams
{
    NSMutableDictionary *modelDict = ((NSDictionary *)[self yy_modelToJSONObject]).mutableCopy;
    
    [modelDict removeObjectForKey:@"extraParam"];
    
    for (NSString *key in self.extraParam.allKeys) {
        modelDict[key] = self.extraParam[key];
    }
    
    return modelDict ?: @{};
}

@end

