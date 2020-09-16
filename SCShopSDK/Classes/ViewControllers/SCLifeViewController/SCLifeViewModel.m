//
//  SCLifeViewModel.m
//  shopping
//
//  Created by gejunyu on 2020/8/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCLifeViewModel.h"
#import "SCCategoryViewModel.h"

@interface SCLifeViewModel ()
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, strong) NSArray <SCCategoryModel *> *categoryList;
@property (nonatomic, strong) NSMutableArray <SCCommodityModel *> *commodityList;
@property (nonatomic, assign) BOOL isRequesting;

@end

@implementation SCLifeViewModel

- (void)requestCategoryList:(NSDictionary *)paramDic success:(SCHttpRequestSuccess)success failure:(SCHttpRequestFailed)failure
{
    [SCCategoryViewModel requestCategory:^(NSArray<SCCategoryModel *> * _Nonnull categoryList) {
        self.categoryList = categoryList;
        [self setModelSelected:paramDic];
        
        if (success) {
            success(nil);
        }
        
    } failure:^(NSString * _Nullable errorMsg) {
        if (failure) {
            failure(errorMsg);
        }
    }];
}



- (void)requestCommodityList:(NSString *)typeNum page:(NSInteger)page completion:(SCHttpRequestCompletion)completion
{
    if (_isRequesting) {
        return;
    }
    
    _isRequesting = YES;
    
    if (!_commodityList) {
        _commodityList = [NSMutableArray array];
        
    }else if (page == 1) {
        [self.commodityList removeAllObjects];
    }
    
    [SCCategoryViewModel requestCommoditiesWithTypeNum:typeNum brandNum:nil tenantNum:nil categoryName:nil cityNum:nil isPreSale:NO sort:SCCategorySortKeySale sortType:SCCategorySortTypeDesc pageNum:page success:^(NSMutableArray<SCCommodityModel *> * _Nonnull commodityList) {
        [self.commodityList addObjectsFromArray:commodityList];
        self.hasMoreData = commodityList.count >= kCountCurPage;
        
        if (completion) {
            completion(nil);
        }
        self.isRequesting = NO;
        
    } failure:^(NSString * _Nullable errorMsg) {
        if (completion) {
            completion(errorMsg);
        }
        self.isRequesting = NO;
    }];
    
}

- (void)setModelSelected:(NSDictionary *)paramDic
{
    //        指定类别 typeNum：分类编码[一级、二级编码都可以]
    //        指定品牌 brandNum：品牌编码

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


@end
