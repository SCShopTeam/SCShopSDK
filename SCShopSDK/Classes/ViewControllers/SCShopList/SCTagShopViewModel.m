//
//  SCTagShopViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCTagShopViewModel.h"
#import "SCCategoryViewModel.h"

@interface SCTagShopViewModel ()
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, strong) NSArray <SCCategoryModel *> *categoryList;
@property (nonatomic, strong) NSMutableArray <SCCommodityModel *> *commodityList;

@end

@implementation SCTagShopViewModel

- (void)requestCategoryList:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    [SCCategoryViewModel requestCategory:^(NSArray<SCCategoryModel *> * _Nonnull categoryList) {
        self.categoryList = categoryList;
        if (success) {
            success(nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        if (failure) {
            failure(errorMsg);
        }
    }];
}

- (void)requestCommodityList:(NSInteger)page completion:(SCHttpRequestCompletion)completion
{
    
    if (self.categoryList.count == 0) {
        if (completion) {
            completion(@"param null");
        }
        return;
    }
    
    if (page == 1) {
        [self.commodityList removeAllObjects];
    }
    
    NSString *typeNum = @"";
    for (SCCategoryModel *model in self.categoryList) {
        if (model.selected) {
            typeNum = model.typeNum;
        }
    }
    
    [SCCategoryViewModel requestCommoditiesWithTypeNum:typeNum brandNum:nil tenantNum:nil categoryName:nil cityNum:nil isPreSale:NO sort:SCCategorySortKeySale sortType:SCCategorySortTypeDesc pageNum:page success:^(NSMutableArray<SCCommodityModel *> * _Nonnull commodityList) {
        [self.commodityList addObjectsFromArray:commodityList];
        self.hasMoreData = commodityList.count >= kCountCurPage;
        
        if (completion) {
            completion(nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        if (completion) {
            completion(errorMsg);
        }
    }];
    
}

- (void)setModelSelected:(NSDictionary *)paramDic
{
    //        指定类别 typeNum：分类编码[一级、二级编码都可以]
    //        指定品牌 brandNum：品牌编码
    if (self.categoryList.count == 0) {
        return;
    }
    
    if (!VALID_DICTIONARY(paramDic)) {
        self.categoryList.firstObject.selected = YES;
        return;
    }
    
    NSString *typeNum = paramDic[@"typeNum"];
    NSString *brandNum = paramDic[@"brandNum"];
    
    
    NSString *categoryNum = VALID_STRING(typeNum) ? typeNum : (VALID_STRING(brandNum) ? brandNum : nil);
    
    if (!categoryNum) {
        self.categoryList.firstObject.selected = YES;
        return ;
    }
    
    __block NSInteger index = 0;
    
    [self.categoryList enumerateObjectsUsingBlock:^(SCCategoryModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.typeNum isEqualToString:categoryNum]) {
            index = idx;
            *stop = YES;
            
        }else {
            for (SecondCategoryModel *sModel in model.secondList) {
                if ([sModel.secondNum isEqualToString:categoryNum]) {
                    index = idx;
                    *stop = YES;
                }
            }
        }
    }];
    
    [self.categoryList enumerateObjectsUsingBlock:^(SCCategoryModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.selected = idx == index;
    }];
    
    
}


- (NSMutableArray<SCCommodityModel *> *)commodityList
{
    if (!_commodityList) {
        _commodityList = [NSMutableArray array];
    }
    return _commodityList;
}

@end
