//
//  SCCategoryViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/6.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCategoryViewModel.h"

@interface SCCategoryViewModel ()
@property (nonatomic, strong) NSArray <SCCategoryModel *> *categoryList;

@end

@implementation SCCategoryViewModel

//分类
+ (void)requestCategory:(SCCategoryBlock)successBlock failure:(SCHttpRequestFailed)failureBlock
{
    [SCRequest scCategoryListBlock:^(BOOL success, NSArray * _Nullable objArr, NSString * _Nullable errMsg) {
        if (!success) {
            if (failureBlock) {
                failureBlock(@"分类信息请求失败");
            }
            return;
        }
        
        NSMutableArray *mulArr = [NSMutableArray array];
        
        for (NSDictionary *dict in objArr) {
            if (!VALID_DICTIONARY(dict)) {
                return;
            }
            SCCategoryModel *model = [SCCategoryModel yy_modelWithDictionary:dict];
            [mulArr addObject:model];
        }
        
        if (mulArr.count > 0) {
            if (successBlock) {
                successBlock(mulArr.copy);
            }
            
        }else {
            if (failureBlock) {
                failureBlock(@"分类信息请求失败");
            }
        }

        

        
    }];
}

//品类列表
+ (void)requestCommoditiesWithTypeNum:(NSString *)typeNum brandNum:(NSString *)brandNum tenantNum:(NSString *)tenantNum categoryName:(NSString *)categoryName cityNum:(NSString *)cityNum isPreSale:(BOOL)isPreSale sort:(SCCategorySortKey)sort sortType:(SCCategorySortType)sortType pageNum:(NSInteger)pageNum success:(SCCommodityBlock)successBlock failure:(SCHttpRequestFailed)failureBlock
{
    NSString *isPreSaleStr = isPreSale ? @"1" : @"0";
    
    NSString *sortStr = @"";
    if (sort == SCCategorySortKeyPrice) {
        sortStr = @"PRICE";
        
    }else if (sort == SCCategorySortKeySale) {
        sortStr = @"SALE";
        
    }else if (sort == SCCategorySortKeyTime) {
        sortStr = @"TIME";
        
    }else if (sort == SCCategorySortKeyRecommand) {
        sortStr = @"SALE"; //先用销量
    }
    
    NSString *sortTypeStr = sortType == SCCategorySortTypeAsc ? @"ASC" : @"DESC";
    
    NSMutableDictionary *param = @{@"typeNum": typeNum ?: @"",
                                   @"brandNum": brandNum ?: @"",
                                   @"categoryName": categoryName ?: @"",
                                   @"cityNum": cityNum ?: @"",
                                   @"isPreSale": isPreSaleStr,
                                   @"sort": sortStr,
                                   @"sortType": sortTypeStr,
                                   kPageNumKey: @(pageNum),
                                   kPageSizeKey: @(kCountCurPage)}.mutableCopy;
    
    if (VALID_STRING(tenantNum)) {
        param[@"tenantNum"]  = tenantNum;
//        param[@"tenantType"] = @"all";
    }
    
    [SCRequest scCategoryCommoditiesList:param block:^(BOOL success, NSDictionary * _Nullable objArr, NSString * _Nullable errMsg) {
        if (!success) {
            if (failureBlock) {
                failureBlock(errMsg);
            }
            return;
        }
        
        NSArray *records = objArr[@"records"];
        
        NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:kCountCurPage];
        
        for (NSDictionary *dict in records) {
            if (!VALID_DICTIONARY(dict)) {
                return;
            }
            SCCommodityModel *model = [SCCommodityModel yy_modelWithDictionary:dict];
            [mulArr addObject:model];
        }
        
        
        
        if (successBlock) {
            successBlock(mulArr);
        }
        
    }];
}


//为你推荐
+ (void)requestRecommend:(SCCommodityBlock)successBlock failure:(SCHttpRequestFailed)failureBlock
{
    [self requestCommoditiesWithTypeNum:nil brandNum:nil tenantNum:nil categoryName:nil cityNum:nil isPreSale:NO sort:SCCategorySortKeySale sortType:SCCategorySortTypeDesc pageNum:1 success:successBlock failure:failureBlock];
}


@end
