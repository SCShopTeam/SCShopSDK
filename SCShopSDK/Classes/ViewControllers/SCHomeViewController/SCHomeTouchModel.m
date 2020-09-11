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
    
    for (NSDictionary *dict in content) {
        if (VALID_DICTIONARY(dict)) {
            SCHomeTouchModel *model = [SCHomeTouchModel yy_modelWithDictionary:dict];
            model.contentName = dict[@"contactName"];
            model.isLoop      = dict[@"isLoop"];
            model.cpmType     = dict[@"cpmType"];
            model.periodCount = [NSString stringWithFormat:@"%@", dict[@"periodCount"]].integerValue;
            model.recallType  = dict[@"recallType"];
            model.contactNum  = dict[@"contactNum"];
            model.periodType  = dict[@"periodType"];
            
            [mulArr addObject:model];
        }
    }
    
    return mulArr;
    
}
//@property (nonatomic, copy) NSString *contactName;
//@property (nonatomic, copy) NSString *isLoop;
//@property (nonatomic, copy) NSString *cpmType;
//@property (nonatomic, assign) NSInteger periodCount;
//@property (nonatomic, copy) NSString *recallType;
//@property (nonatomic, copy) NSString *contactNum;
//@property (nonatomic, copy) NSString *periodType;

@end

